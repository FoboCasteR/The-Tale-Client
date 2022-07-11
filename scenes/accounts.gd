extends Node

export(PackedScene) var account_scene
export(NodePath) onready var accounts_list_node = get_node(accounts_list_node)
export(NodePath) onready var remove_account_node = get_node(remove_account_node)

var accounts := []
var selected_account

onready var accounts_manager = AccountsManager.new()


func _ready():
	var accounts = accounts_manager.list_accounts()

	for account in accounts:
		var account_node = account_scene.instance()
		accounts_list_node.add_child(account_node)
		account_node.account = account
		account_node.connect("account_selected", self, "_on_account_selected")
		account_node.connect("account_confirmed", self, "_on_account_confirmed")

	print_debug(self.get_incoming_connections())


func _on_AddAccountButton_pressed():
	get_tree().change_scene("res://scenes/login.tscn")


func _on_RemoveAccountButton_pressed():
	for account_node in accounts_list_node.get_children():
		if account_node.account == selected_account:
			account_node.queue_free()
			break

	$TheTaleAPI.session_id = selected_account.session_id
	$TheTaleAPI.logout()
	$TheTaleAPI.session_id = ""

	accounts_manager.remove_account(selected_account)
	selected_account = null
	remove_account_node.disabled = true


func _on_account_selected(account: Account):
	selected_account = account
	remove_account_node.disabled = false


func _on_account_confirmed(account: Account):
	EventBus.emit_signal("account_changed", account)
	get_tree().change_scene("res://scenes/game.tscn")
