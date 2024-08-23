extends RichTextLabel

var defult_text = "CURRENT SCORE: "

func _process(delta: float) -> void:
	var display_text = str(defult_text,str(GlobalScript.current_score))
	self.text = display_text
