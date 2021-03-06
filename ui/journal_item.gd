extends PanelContainer

var message: JournalMessage setget set_message

onready var text_label = $TextLabel


func set_message(value: JournalMessage):
	message = value
	call_deferred("update_ui")


func update_ui():
	text_label.clear()
	text_label.add_text(message.text)

	var template = TheTaleData.linguistics.get(message.type)
	if template:
		text_label.newline()

		var data = {}
		for key in message.data:
			var value = message.data[key]
			match typeof(value):
				TYPE_STRING:
					data[key] = Utils.upcase_first(value)
				_:
					data[key] = value

		text_label.append_bbcode(template.format(data))
