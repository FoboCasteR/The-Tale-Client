extends Button

signal account_selected(account)
signal account_confirmed(account)

var account: Account setget set_account
var account_selected: bool = false


func _ready():
	account_selected = pressed


func set_account(value: Account):
	account = value
	update_ui()


func update_ui():
	$Description.clear()
	$Description.push_bold()
	$Description.add_text(account.name)
	$Description.pop()
	$Description.newline()
	$Description.add_text(Utils.format_datetime(OS.get_datetime_from_unix_time(account.session_expires_at)))


func _on_Account_toggled(button_pressed: bool):
	var confirmed: bool = false

	if account_selected and button_pressed:
		confirmed = true

	account_selected = button_pressed

	if account_selected:
		emit_signal("account_selected", account)

	if confirmed:
		emit_signal("account_confirmed", account)
