extends RichTextLabel


var defult_text = "PREVIOUS SCORE: "

func _process(delta: float) -> void:
	var display_text = str(defult_text,str(GlobalScript.previous_score))
	self.text = display_text
