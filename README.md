gdunzip
=======

Gdunzip is a  zip file browser/decompressor written entirely in a single
GDScript file. You can use this in games you're building with the Godot game
engine. This script is meant for modest zip decompressing purposes, since the
inflate algorithm it contains isn't super fast and gdunzip doesn't do CRC
checks of the uncompressed files. However, gdunzip works fine if you only need
to decompress small files, or when your zip files contain precompressed files
like png's.

In order to create gdunzip, I have made a GDScript port of Jørgen Ibsen's
excellent tiny inflate library: [tinf](https://bitbucket.org/jibsen/tinf) for
decompressing the deflate streams. Since the original was written in C and used
some nifty pointer arithmetic, I had to make some minor changes
here and there to be able to translate it. However, I tried to stay as close to
the original code as possible.

The zip file format parsing is all written from scratch and performs pretty
well.

Why I wrote gdunzip
-------------------
I'm working on a little sideproject in Godot: a memorize app. In this app I
will allow the user to import an ODS-file: the spreadsheet file format used by
LibreOffice and OpenOffice. ODS-files are actually zip files, containing a
bunch of xml files and some other assets. I couldn't find a ready-made ODS
library for Godot, so I set out creating one. It would have been faster to just
use GDNative and hand all the work to a C++ library, but since this is a hobby
project and I haven't got much GDScript experience, I thought it would be fun
to create it myself. The first step was of course to get an unzipper up and
running. I found out that Godot's PoolByteArray has a "decompress" function
that supports deflate streams, however these were all in the Zlib format, so
you can't use it with regular zip files (zlib uses an Adler-32 checksum to
verify decompressed data, but zip files only contain a CRC-32 checksum).

A more sensible person might have just stepped back and pulled some
pre-existing C++ library off the shelf, however I thought it would be fun to
dive in and gdunzip is the result :-).

Using gdunzip
-------------
- Grab
  [gdunzip.gd](https://raw.githubusercontent.com/jellehermsen/gdunzip/master/addons/gdunzip/gdunzip.gd).
- Put gdunzip.gd somewhere in your Godot project.
- Make an instance, load a file and start uncompressing:

```gdscript
# Instance the gdunzip script
var gdunzip = load('res://PATH_TO_SCRIPT/gdunzip.gd').new()

# Load a zip file
var loaded = gdunzip.load('res://test.zip')

# Uncompress a file, getting a PoolByteArray in return 
# (or false if it failed uncompressing) 
if loaded:
    var uncompressed = gdunzip.uncompress('lorem.txt')
    if !uncompressed:
        print('Failed uncompressing lorem.txt')
    else:
        print(uncompressed.get_string_from_utf8())
else:
    print('Failed loading zip file')
```

- When gdunzip has loaded a zip file, you can iterate over all the files inside, by
  looping through the "files" attribute:
```gdscript
for f in gdunzip.files:
    print('File name: ' + f['file_name'])

    # "compression_method" will be either -1 for uncompressed data, or
    # File.COMPRESSION_DEFLATE for deflate streams
    print('Compression method: ' + str(f['compression_method']))

    print('Compressed size: ' + str(f['compressed_size']))

    print('Uncompressed size: ' + str(f['uncompressed_size']))
```

Class documentation
-------------------

### Member functions
| Returns                          | Function name          |
| -------------------------------- | ---------------------- |
| bool                             | load(String path)      |
| PoolByteArray                    | uncompress(String file_name)|
| PoolByteArray | get_compressed(String file_name) |

### Member function description

- bool **load**(String path)

Tries to load a zip file with a given path. Returns false if it failed
loading the zip, or true if it was successfull.

- PoolByteArray **uncompress**(String file_name)

Try to uncompress the given file in the loaded zip. The file_name can include
directories. This function returns *false* if the file can't be found, or if
there's an error during uncompression. 

- PoolByteArray **get_compressed**(String file_name)

Returns the compressed data for a given file name (or false if the file can't
be found). Depending on the file compression it can be either uncompressed or a
raw deflate stream. This function returns *false* if the file can't be found.

### files attribute
After you have loaded a file, the gdunzip instance will have a pre-filled
"files" attribute. This is simply an dictionary containing the meta data for
the files that reside in the zip. The dictionary is a mapping from file name
(including directory) to another directory with the following keys:

- file_name: the file name
- compression_method: -1 if uncompressed or File.COMPRESSION_DEFLATE
- file_header_offset: the exact byte location of this file's compressed data
  inside the zip file
- compressed_size: the compressed file size in bytes
- uncompressed_size: the uncompressed file size in bytes
