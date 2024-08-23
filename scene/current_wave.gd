extends RichTextLabel
var defult_text = "CURRENT WAVE: "

func _process(delta: float) -> void:
	var display_text = str(defult_text,str(GlobalScript.current_wave))
	self.text = display_text
