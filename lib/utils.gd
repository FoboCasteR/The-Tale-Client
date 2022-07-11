class_name Utils


static func upcase_first(value: String) -> String:
	return value[0].to_upper() + value.substr(1, -1)


static func format_datetime(value: Dictionary) -> String:
	var day = "%02d" % value.get("day")
	var month = "%02d" % value.get("month")
	var hour = "%02d" % value.get("hour")
	var minute = "%02d" % value.get("minute")
	var second = "%02d" % value.get("second")

	return "{0}.{1}.{2} {3}:{4}:{5}".format([day, month, value.get("year"), hour, minute, second])
