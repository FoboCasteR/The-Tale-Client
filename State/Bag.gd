class_name Bag

var size: int
var items: Array = []


func clear():
	items.clear()


func add_item(item: Artifact):
	items.append(item)
