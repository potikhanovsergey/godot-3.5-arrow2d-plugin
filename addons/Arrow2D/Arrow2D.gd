tool
extends Node2D

export(Vector2) var target = null setget set_target

var cached_target
var cached_pos

export(int) var width = 4 setget set_width

export(float) var start_offset = 0 setget set_start_offset
export(float) var end_offset = 0 setget set_end_offset
export(float) var side_offset = 0 setget set_side_offset
export(float) var max_length = 0 setget set_max_length
export(float) var min_length = 0 setget set_min_length

export(Color) var color = null setget set_color

export(bool) var editor_only = false

func _ready():
	if is_visible():
		set_process(true)

func _draw():
	if not is_visible():
		return
	
	if target == null:
		return
	
	if color == null:
		color = Color(1,1,1,1)
	
	var points = PoolVector2Array()
	var colors = PoolColorArray()
	
	var arrowvec: Vector2
	
	if max_length == 0:
		arrowvec = target - global_position
	else:
		arrowvec = (target - global_position).clamped(max_length)
		
	var arrow_length = arrowvec.length()	
	if min_length != 0 and arrow_length < min_length and arrow_length != 0:
		arrowvec = arrowvec * (min_length / arrow_length)
		
	var sidedir = Vector2(arrowvec.y, -arrowvec.x).normalized()
	var sidevec = sidedir * width * 0.5
	var pointvec = arrowvec.normalized() * width
	
	var startoffset = arrowvec.normalized() * start_offset
	var endoffset = -arrowvec.normalized() * end_offset
	var sideoffset = sidedir * side_offset
	
	points.append(sideoffset + startoffset + sidevec)
	colors.append(color)
	points.append(sideoffset + endoffset + sidevec + arrowvec - pointvec)
	colors.append(color)
	points.append(sideoffset + endoffset + 2*sidevec + arrowvec - pointvec)
	colors.append(color)
	points.append(sideoffset + endoffset + arrowvec)
	colors.append(color)
	points.append(sideoffset + endoffset - 2*sidevec + arrowvec - pointvec)
	colors.append(color)
	points.append(sideoffset + endoffset - sidevec + arrowvec - pointvec)
	colors.append(color)
	points.append(sideoffset + startoffset - sidevec)
	colors.append(color)
	
	self.draw_polygon(points, colors)

func set_target(p_target):
	if p_target != cached_target:
		target = p_target
		cached_target = target
		update()

func set_width(p_width):
	width = p_width
	update()

func _process(delta):
	if global_position != cached_pos:
		cached_pos = global_position
		update()

func is_visible():
	return not editor_only or get_tree().is_editor_hint()

func set_start_offset(value):
	start_offset = value
	update()
	
func set_start_position(value):
	position = value
	update()

func set_end_offset(value):
	end_offset = value
	update()

func set_side_offset(value):
	side_offset = value
	update()

func set_color(value):
	color = value
	update()

func set_max_length(value):
	max_length = value
	update()

func set_min_length(value):
	min_length = value
	update()
