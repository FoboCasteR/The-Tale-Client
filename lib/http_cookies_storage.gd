class_name HTTPCookiesStorage

const COOKIES_PATH = "user://cookies.dat"

var _cookies := {}


func set_cookie(value: String):
	var cookie := HTTPCookieParser.parse(value)
	_cookies[cookie.name] = cookie


func get_cookie(name) -> HTTPCookie:
	return _cookies[name]


func get_cookies() -> Array:
	var cookies = []

	for cookie_name in _cookies:
		var cookie := _cookies[cookie_name] as HTTPCookie

		if not cookie.is_expired():
			cookies.append(cookie)

	return cookies


func save():
	var file := File.new()

	file.open_encrypted_with_pass(COOKIES_PATH, File.WRITE, OS.get_unique_id())

	for cookie_name in _cookies:
		file.store_line(_cookies[cookie_name].raw)

	file.close()


func load():
	var file := File.new()

	if not file.file_exists(COOKIES_PATH):
		return

	file.open_encrypted_with_pass(COOKIES_PATH, File.READ, OS.get_unique_id())

	while file.get_position() < file.get_len():
		var raw_cookie := file.get_line()
		var cookie := HTTPCookieParser.parse(raw_cookie)
		_cookies[cookie.name] = cookie

	file.close()
