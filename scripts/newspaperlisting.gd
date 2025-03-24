extends ColorRect

@onready var title: Label = $title
@onready var desc: Label = $desc
@onready var amount: Label = $amount

func setup(qst):
	title.text = qst[0]
	desc.text = qst[1]
	amount.text = ("%.2f/%.2f" if !qst[4] else "%.0f/%.0f") % [qst[2],qst[3]]
