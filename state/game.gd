extends Node

var account
var action := HeroAction.new()
var bag := Bag.new()
var companion := Companion.new()
var diary_messages := Array()
var diary_version := 0
var equipment := Array()
var hero := Hero.new()
var journal_messages := Array()
var quests := Array()
var turn := Turn.new()


func _ready():
	EventBus.connect("account_changed", self, "_set_account")
	EventBus.connect("server_state_updated", self, "_set_state")
	EventBus.connect("session_ended", self, "_reset_state")
	EventBus.connect("diary_updated", self, "_set_diary")


func _set_account(value):
	account = value


func _set_state(value: Dictionary) -> void:
	var account_info = value.get("account")

	if account_info.get("is_old"):
		return

	var hero_data = account_info.get("hero")

	_update_turn(value.get("turn"))
	_update_hero(hero_data)

	var action_data = hero_data.get("action")
	if action_data:
		_update_action(action_data)

	var equipment_data = hero_data.get("equipment")
	if typeof(equipment_data) == TYPE_DICTIONARY:
		_update_equipment(equipment_data)

	var bag_data = hero_data.get("bag")
	if typeof(bag_data) == TYPE_DICTIONARY:
		_update_bag(bag_data, hero_data)

	var messages_data = hero_data.get("messages")
	if messages_data:
		_update_journal_messages(messages_data)

	if hero_data.has("companion"):
		var companion_data = hero_data.get("companion")
		match typeof(companion_data):
			TYPE_NIL:
				_update_companion(false)
			TYPE_DICTIONARY:
				_update_companion(true, companion_data)

	if hero_data.has("quests"):
		_update_quests(hero_data.get("quests"))

	var diary_data = int(hero_data.get("diary"))
	if diary_data and diary_data != diary_version:
		diary_version = diary_data
		EventBus.emit_signal("diary_version_changed", diary_version)


func _set_diary(value: Dictionary):
	if value.get("version") != diary_version:
		return

	diary_messages.clear()

	var messages_data = value.get("messages")

	for message_data in messages_data:
		var message = DiaryMessage.new()
		message.set_from_json(message_data)
		diary_messages.append(message)

	diary_messages.invert()

	EventBus.emit_signal("diary_messages_changed", diary_messages)


func _reset_state():
	account = null
	action = HeroAction.new()
	bag = Bag.new()
	companion = Companion.new()
	diary_version = 0
	diary_messages = Array()
	equipment = Array()
	hero = Hero.new()
	journal_messages = Array()
	quests = Array()
	turn = Turn.new()


func _update_turn(value: Dictionary):
	turn.set_from_json(value)
	EventBus.emit_signal("turn_changed", turn)


func _update_action(value: Dictionary):
	action.set_from_json(value)
	EventBus.emit_signal("action_changed", action)


func _update_hero(value: Dictionary):
	hero.set_from_json(value)
	EventBus.emit_signal("hero_changed", hero)


func _update_companion(present: bool, data: Dictionary = {}):
	companion.present = present
	if present:
		companion.set_from_json(data)
	EventBus.emit_signal("companion_changed", companion)


func _update_equipment(value: Dictionary):
	equipment.clear()

	for key in value:
		var artifact = Artifact.new()
		artifact.set_from_json(value[key])
		equipment.append(artifact)

	EventBus.emit_signal("equipment_changed", equipment)


func _update_bag(bag_data: Dictionary, hero_data: Dictionary):
	bag.clear()

	var hero_secondary_data = hero_data.get("secondary")
	if hero_secondary_data:
		bag.size = hero_secondary_data.get("max_bag_size")

	for key in bag_data:
		var artifact = Artifact.new()
		artifact.set_from_json(bag_data[key])
		bag.add_item(artifact)

	bag.items.sort_custom(Sorters, "artifacts_by_name")

	EventBus.emit_signal("bag_changed", bag)


func _update_journal_messages(messages_data: Array):
	journal_messages.clear()

	for message_data in messages_data:
		var message = JournalMessage.new()
		message.set_from_json(message_data)
		journal_messages.append(message)

	journal_messages.invert()

	EventBus.emit_signal("journal_messages_changed", journal_messages)


func _update_quests(quests_data: Dictionary):
	quests.clear()

	var lines = quests_data.get("quests")

	for line in lines:
		for quest_data in line.get("line"):
			var quest = Quest.new()
			quest.set_from_json(quest_data)
			quests.append(quest)

	EventBus.emit_signal("quests_changed", quests)
