extends Node

const BASE_URL = "https://the-tale.org"
const API_CLIENT = "TheTaleClient-dev"
const DEFAULT_HEADERS = [
	"Referer: %s/" % BASE_URL,
	"User-Agent: TheTaleClient/dev (https://github.com/FoboCasteR/The-Tale-Client)",
]
const COOKIES_PATH = "user://tt_cookies.dat"

var http_client := HTTPClient.new()
var cookies := {}


func _init():
	_load_cookies()


func _save_cookies():
	var file := File.new()

	file.open(COOKIES_PATH, File.WRITE)

	for cookie_name in cookies:
		file.store_line(cookies[cookie_name].raw)

	file.close()


func _load_cookies():
	var file := File.new()

	if not file.file_exists(COOKIES_PATH):
		return

	file.open(COOKIES_PATH, File.READ)

	while file.get_position() < file.get_len():
		var raw_cookie := file.get_line()
		var cookie := HTTPCookieParser.parse(raw_cookie)
		cookies[cookie.name] = cookie

	file.close()


func _query_string_from_dict(query: Dictionary) -> String:
	return http_client.query_string_from_dict(query)


func _build_url(path := "/", query := {}) -> String:
	var result := BASE_URL + path

	if not query.empty():
		result += "?" + _query_string_from_dict(query)

	return result


func _headers_to_dict(headers: Array) -> Dictionary:
	var result = {}

	for header in headers:
		var kv := (header as String).split(":", true, 1)
		var key := (kv[0] as String).to_lower()
		var value := kv[1].strip_edges()

		if result.has(key):
			result[key].append(value)
		else:
			result[key] = [value]

	return result


func _extract_cookies(headers: Dictionary) -> void:
	var should_save = false
	var prev_cookies = cookies.duplicate(true)

	for value in headers["set-cookie"]:
		var cookie := HTTPCookieParser.parse(value)
		cookies[cookie.name] = cookie

		if not (prev_cookies and prev_cookies[cookie.name] == cookie):
			should_save = true

	if should_save:
		_save_cookies()


func _set_cookie_list(headers: Array) -> Array:
	var cookie_list := PoolStringArray()

	for cookie_name in cookies:
		var cookie := cookies[cookie_name] as HTTPCookie

		if not cookie.is_expired():
			cookie_list.append(cookie.name + "=" + cookie.value)

	if cookie_list.empty():
		return headers

	var result := headers.duplicate()
	result.append("Cookie: " + cookie_list.join("; "))
	return result


func _make_get_request(url: String, query := {}, custom_headers := []):
	var headers = _set_cookie_list(DEFAULT_HEADERS)

	headers.append_array(custom_headers)

	$HTTPRequest.request(_build_url(url, query), headers, true, HTTPClient.METHOD_GET)

	return callv("_get_data_from_response", yield($HTTPRequest, "request_completed"))


func _make_post_request(url: String, query := {}, custom_headers := [], payload := {}):
	var urlencoded_payload := _query_string_from_dict(payload)
	var headers := _set_cookie_list(DEFAULT_HEADERS)

	headers.append_array(custom_headers)
	if not payload.empty():
		headers.append_array(
			["Content-Type: application/x-www-form-urlencoded", "Content-Length: %s" % urlencoded_payload.length()]
		)
	headers.append("X-CSRFToken: %s" % cookies["csrftoken"].value)

	$HTTPRequest.request(_build_url(url, query), headers, true, HTTPClient.METHOD_POST, urlencoded_payload)

	return callv("_get_data_from_response", yield($HTTPRequest, "request_completed"))


func _get_data_from_response(result: int, response_code: int, headers: Array, body: PoolByteArray):
	if result != HTTPRequest.RESULT_SUCCESS:
		return

	var headers_dict = _headers_to_dict(headers)

	print_debug("[%s] - %s" % [response_code, headers_dict])

	_extract_cookies(headers_dict)

	if response_code >= 200 and response_code < 300:
		var body_str = body.get_string_from_utf8()
		var pr = JSON.parse(body_str)

		if pr.error == OK:
			print_debug(pr.result)

			if pr.result["status"] == "ok":
				return pr.result["data"]
		else:
			print_debug(body_str)


func info():
	return _make_get_request("/api/info", {"api_version": "1.1", "api_client": API_CLIENT})


func login(email: String, password: String, _remember: bool = false):
	return _make_post_request(
		"/accounts/auth/api/login",
		{
			"api_version": "1.0",
			"api_client": API_CLIENT,
		},
		[],
		{"email": email, "password": password}
	)


func logout():
	return _make_post_request(
		"/accounts/auth/api/logout",
		{
			"api_version": "1.0",
			"api_client": API_CLIENT,
		}
	)
