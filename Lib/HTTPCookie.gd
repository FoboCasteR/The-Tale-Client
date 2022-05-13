class_name HTTPCookie

var raw: String
var name: String
var value: String
var expires: int
var max_age: int


func is_expired() -> bool:
	return (max_age and not max_age > 0) or (expires < OS.get_unix_time())
