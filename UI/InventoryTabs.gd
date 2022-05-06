extends TabContainer


func _ready():
	GameState.connect("bag_changed", self, "_update_ui")

	set_tab_title(0, "Экипировка")
	set_tab_title(1, "Рюкзак")


func _exit_tree():
	GameState.disconnect("bag_changed", self, "_update_ui")


func _update_ui(bag: Bag):
	set_tab_title(1, "Рюкзак (%d/%d)" % [bag.items.size(), bag.size])
