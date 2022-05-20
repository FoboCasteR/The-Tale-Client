class_name HTTPCookieParser

# gdlint:ignore = max-line-length
const HTTP_DATE_PATTERN = "^(?<weekday>Mon|Tue|Wed|Thu|Fri|Sat|Sun), (?<day>[0-3][0-9]) (?<month>Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (?<year>[0-9]{4}) (?<hour>[01][0-9]|2[0-3]):(?<minute>[0-5][0-9]):(?<second>[0-5][0-9]) GMT$"
const MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]


static func parse(value: String) -> HTTPCookie:
	var cookie := HTTPCookie.new()

	cookie.raw = value

	var props := Array(value.split(";"))
	var cookie_name_value := (props.pop_front() as String).strip_edges().split("=", true, 1)

	cookie.name = cookie_name_value[0]
	cookie.value = cookie_name_value[1]

	for prop in props:
		var prop_name_value := (prop as String).strip_edges().split("=", true, 1)
		match prop_name_value[0].to_lower():
			"expires":
				cookie.expires = parse_http_date(prop_name_value[1])
			"max-age":
				cookie.max_age = int(prop_name_value[1])

	return cookie


static func parse_http_date(http_date: String) -> int:
	var regex := RegEx.new()
	regex.compile(HTTP_DATE_PATTERN)
	var matches := regex.search(http_date)
	var datetime := {}

	for key in ["year", "month", "day", "hour", "minute", "second"]:
		datetime[key] = matches.get_string(key)

	datetime["month"] = MONTHS.find(datetime["month"]) + 1

	return OS.get_unix_time_from_datetime(datetime)
