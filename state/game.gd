extends Node

var account
var action := HeroAction.new()
var bag := Bag.new()
var companion := Companion.new()
var equipment := Array()
var hero := Hero.new()
var is_old := true
var messages := Array()
var quests := Array()
var turn := Turn.new()


func _ready():
	EventBus.connect("account_changed", self, "_set_account")
	EventBus.connect("server_state_updated", self, "_set_state")
	EventBus.connect("session_ended", self, "_reset_state")


func _set_account(value):
	account = value


func _set_state(value: Dictionary) -> void:
	_update_turn(value.get("turn"))

	var account_info = value.get("account")

	var hero_data = account_info.get("hero")

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
		_update_messages(messages_data)

	if hero_data.has("companion"):
		var companion_data = hero_data.get("companion")
		match typeof(companion_data):
			TYPE_NIL:
				_update_companion(false)
			TYPE_DICTIONARY:
				_update_companion(true, companion_data)

	if hero_data.has("quests"):
		_update_quests(hero_data.get("quests"))


func _reset_state():
	account = null
	action = HeroAction.new()
	bag = Bag.new()
	companion = Companion.new()
	equipment = Array()
	hero = Hero.new()
	messages = Array()
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


func _update_messages(messages_data: Array):
	messages.clear()

	for message_data in messages_data:
		var message = Message.new()
		message.set_from_json(message_data)
		messages.append(message)

	messages.invert()

	EventBus.emit_signal("messages_changed", messages)


func _update_quests(quests_data: Dictionary):
	quests.clear()

	var lines = quests_data.get("quests")

	for line in lines:
		for quest_data in line.get("line"):
			var quest = Quest.new()
			quest.set_from_json(quest_data)
			quests.append(quest)

	EventBus.emit_signal("quests_changed", quests)
