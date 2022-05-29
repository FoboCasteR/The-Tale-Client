class_name CSRFTokenGenerator

const SIZE = 32

var value: String
var _crypto := Crypto.new()


func _init():
	next()


func next():
	value = _crypto.generate_random_bytes(SIZE).hex_encode()
	return value
