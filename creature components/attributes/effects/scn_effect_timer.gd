extends Timer
signal effect_end(effectname:String)
var linkedEffect:String

func _on_timeout() -> void:
    effect_end.emit(linkedEffect)
    if one_shot:
        queue_free()
 