extends TabContainer


func _ready():
	set_tab_title(0, "Журнал")
	set_tab_title(1, "Дневник")
	set_tab_title(2, "Задания")
	set_tab_disabled(1, true)
