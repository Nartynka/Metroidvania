tool
extends TileSet


func _is_tile_bound(id, neighbour_id):
	return neighbour_id in get_tiles_ids()
