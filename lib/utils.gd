class_name Utils


static func upcase_first(value: String) -> String:
	return value[0].to_upper() + value.substr(1, -1)
