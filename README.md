gdunzip
=======

A zip file browser/decompressor written entirely in GDScript, for usage in the Godot game engine.

Using gdunzip
-------------
- Grab [gdunzip.gd](https://raw.githubusercontent.com/jellehermsen/gdunzip/master/src/gdunzip.gd).
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

- When gdunzip has loaded a zip file, you can iterate all the files inside, by
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
