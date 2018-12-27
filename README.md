gdunzip
=======

A zip file browser/decompressor written entirely in GDScript, for usage in the Godot game engine.

Example usage:

- put gdunzip.gd somewhere in your Godot project
- instance this scrip by using: ```var gdunzip = load('res://LOCATION_IN_LIBRARY/gdunzip.gd').new()```
- load a zip file:
  ```var loaded = gdunzip.load('res://PATH_TO_ZIP/test.zip')```
- if loaded is true you can try to uncompress a file:
  ```var uncompressed = gdunzip.uncompress('PATH_TO_FILE_IN_ZIP/test.txt')````
- now you have got a PoolByteArray named "uncompressed" with the
  uncompressed data for the given file

You can iterate over the "files" variable from the gdunzip instance, to
see all the available files:
```gdscript
for f in gdunzip.files:
    print(f['file_name'])
```
