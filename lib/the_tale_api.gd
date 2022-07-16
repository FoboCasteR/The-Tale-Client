class_name TheTaleAPI
extends Node

# https://docs.the-tale.org/ru/stable/external_api/methods.html

const BASE_URL = "https://the-tale.org"
const API_CLIENT = "TheTaleClient-dev"
const DEFAULT_HEADERS = [
	"Referer: %s/" % BASE_URL,
	"User-Agent: TheTaleClient/dev (https://github.com/FoboCasteR/The-Tale-Client)",
]
const REQUESTS_GROUP = "http_requests"

var http_client := HTTPClient.new()
var csrf_token_gen := CSRFTokenGenerator.new()
var session_id: String


class Response:
	var status: int
	var headers: Array
	var body setget set_body

	var _cookies: Dictionary = {}
	var _headers_dict: Dictionary = {}

	func is_success():
		return status >= 200 and status < 300

	func headers_as_dict():
		if not _headers_dict:
			for header in headers:
				var kv := (header as String).split(":", true, 1)
				var key := (kv[0] as String).to_lower()
				var value := kv[1].strip_edges()

				if _headers_dict.has(key):
					_headers_dict[key].append(value)
				else:
					_headers_dict[key] = [value]

		return _headers_dict

	func cookies():
		if not _cookies:
			for value in headers_as_dict().get("set-cookie"):
				var cookie = HTTPCookieParser.parse(value)
				_cookies[cookie.name] = cookie

		return _cookies

	func set_body(value: PoolByteArray):
		var body_str = value.get_string_from_utf8()
		var pr = JSON.parse(body_str)

		if pr.error == OK:
			body = pr.result


class NullResponse:
	extends Response

	func is_success():
		return false


func _query_string_from_dict(query: Dictionary) -> String:
	return http_client.query_string_from_dict(query)


func _build_url(path := "/", query := {}) -> String:
	var result := BASE_URL + path

	if not query.empty():
		result += "?" + _query_string_from_dict(query)

	return result


func _build_http_request() -> HTTPRequest:
	var http_request = HTTPRequest.new()

	http_request.add_to_group(REQUESTS_GROUP)
	http_request.use_threads = true
	add_child(http_request)

	return http_request


func _add_cookie_to_headers(headers: Array, csrf_token: String = "") -> Array:
	var cookie_list := PoolStringArray()

	if session_id:
		cookie_list.append("sessionid=%s" % session_id)

	if csrf_token:
		cookie_list.append("csrftoken=%s" % csrf_token)

	if cookie_list.empty():
		return headers

	var result := headers.duplicate()
	result.append("Cookie: " + cookie_list.join("; "))
	return result


func _make_get_request(url: String, query := {}, custom_headers := []):
	var headers = _add_cookie_to_headers(DEFAULT_HEADERS)

	headers.append_array(custom_headers)

	var http_request = _build_http_request()
	http_request.request(_build_url(url, query), headers, true, HTTPClient.METHOD_GET)

	var response: Array = yield(http_request, "request_completed")
	http_request.queue_free()
	return callv("_build_response", response)


func _make_post_request(url: String, query := {}, custom_headers := [], payload := {}):
	var urlencoded_payload := _query_string_from_dict(payload)
	var csrf_token = csrf_token_gen.next()
	var headers := _add_cookie_to_headers(DEFAULT_HEADERS, csrf_token)

	headers.append_array(custom_headers)
	if not payload.empty():
		headers.append_array(
			["Content-Type: application/x-www-form-urlencoded", "Content-Length: %s" % urlencoded_payload.length()]
		)
	headers.append("X-CSRFToken: %s" % csrf_token)

	var http_request = _build_http_request()
	http_request.request(_build_url(url, query), headers, true, HTTPClient.METHOD_POST, urlencoded_payload)

	var response: Array = yield(http_request, "request_completed")
	http_request.queue_free()
	return callv("_build_response", response)


func _build_response(result: int, response_code: int, headers: Array, body: PoolByteArray):
	if result != HTTPRequest.RESULT_SUCCESS:
		return NullResponse.new()

	var response = Response.new()

	response.status = response_code
	response.headers = headers
	response.body = body

	return response


func info():
	return _make_get_request("/api/info", {"api_version": "1.1", "api_client": API_CLIENT})


func login(email: String, password: String):
	return _make_post_request(
		"/accounts/auth/api/login",
		{
			"api_version": "1.0",
			"api_client": API_CLIENT,
		},
		[],
		{"email": email, "password": password, "remember": "1"}
	)


func logout():
	for node in get_tree().get_nodes_in_group(REQUESTS_GROUP):
		(node as HTTPRequest).cancel_request()

	return _make_post_request(
		"/accounts/auth/api/logout",
		{
			"api_version": "1.0",
			"api_client": API_CLIENT,
		}
	)


func game_info(account: String = "", client_turns: Array = []):
	return _make_get_request(
		"/game/api/info",
		{
			"api_version": "1.10",
			"api_client": API_CLIENT,
			"account": account,
			"client_turns": PoolStringArray(client_turns).join(",")
		}
	)


func choose(option_uid: String):
	return _make_post_request(
		"/game/quests/api/choose", {"api_version": "1.0", "api_client": API_CLIENT, "option_uid": option_uid}
	)


func diary():
	return _make_get_request("/game/api/diary", {"api_version": "1.0", "api_client": API_CLIENT})
