extends Line2D
class_name TrainLine

@export var train: TrainTexture
@export var speed: float = 100.0
@export var rotation_time:float = 0.5

func _ready() -> void:
	var pts = points.duplicate()
	for pt_index in pts.size():
		pts[pt_index] -= (train.size)/2
		
	if (not train) or (pts.size() < 2): return

	train.color = default_color
	
	train.position = pts[0]
	train.rotation = (pts[1] - pts[0]).angle()

	var tween := create_tween()
	tween.set_loops()
	
	for i in pts.size():
		var prev = pts[i - 1] if not (i-1 < 0) else pts[i]
		var curr = pts[i]
		var direction = (curr - prev).angle() + PI/2
		var distance = prev.distance_to(curr)
		var time_taken = distance / speed
		
		tween.tween_property(train, "rotation", direction, rotation_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.parallel().tween_property(train, "position", curr, time_taken).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(train._ready)
