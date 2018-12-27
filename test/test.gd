extends SceneTree

func _init():
    var gdunzip = load('res://src/gdunzip.gd').new()
    var loaded = gdunzip.load('res://test/lorem.zip')
    if loaded:
        var uncompressed = gdunzip.uncompress('lorem.txt')
        if !uncompressed:
            print('Error uncompressing')
        else:
            print(uncompressed.get_string_from_utf8())
    else:
        print('Error while loading zip file')
    quit()
