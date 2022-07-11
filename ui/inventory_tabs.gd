extends TabContainer


func _ready():
	EventBus.connect("bag_changed", self, "_update_ui")

	set_tab_title(0, "Экипировка")
	set_tab_title(1, "Рюкзак")


func _exit_tree():
	EventBus.disconnect("bag_changed", self, "_update_ui")


func _update_ui(bag: Bag):
	set_tab_title(1, "Рюкзак (%d/%d)" % [bag.items.size(), bag.size])
