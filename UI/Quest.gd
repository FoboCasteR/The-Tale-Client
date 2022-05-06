extends PanelContainer

var quest: Quest setget set_quest

onready var text_label = $TextLabel


func set_quest(value: Quest):
	quest = value
	call_deferred("update_ui")


func update_ui():
	text_label.clear()

	text_label.append_bbcode("[b]" + quest.name + "[/b]")

	if quest.experience:
		text_label.newline()
		text_label.add_text("+{0}XP, +{1} влияния".format([quest.experience, quest.power]))

	for actor in quest.actors:
		match actor.type:
			Quest.Actor.TYPE.PERSON, Quest.Actor.TYPE.PLACE:
				text_label.newline()
				text_label.add_text(Utils.upcase_first(actor.title) + ": " + actor.data.name)
			Quest.Actor.TYPE.SPENDING:
				text_label.newline()
				text_label.add_text("Цель: " + actor.data.goal)
				text_label.newline()
				text_label.add_text(actor.data.description)

	if quest.action:
		text_label.newline()
		text_label.add_text(quest.action)
