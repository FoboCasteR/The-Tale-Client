class_name AccountsManager

const DIR_PATH = "user://accounts"


func list_accounts():
	var accounts = []
	var dir = Directory.new()
	dir.make_dir(DIR_PATH)

	var err = dir.open(DIR_PATH)
	if err == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.get_extension() == "dat":
				var account = load_account(file_name.get_basename())
				if account:
					accounts.append(account)
			file_name = dir.get_next()
		dir.list_dir_end()

	return accounts


func add_account(account: Account):
	var file := File.new()
	var path = DIR_PATH.plus_file("%s.dat" % account.id)
	var err = file.open_encrypted_with_pass(path, File.WRITE, OS.get_unique_id())

	if err == OK:
		file.store_pascal_string(var2str(account))
		file.close()


func load_account(account_id):
	var account
	var file := File.new()
	var path = DIR_PATH.plus_file("%s.dat" % account_id)

	if not file.file_exists(path):
		return

	var err = file.open_encrypted_with_pass(path, File.READ, OS.get_unique_id())

	if err == OK:
		account = str2var(file.get_pascal_string())
		file.close()

		return account


func remove_account(account: Account):
	var dir = Directory.new()
	var path = DIR_PATH.plus_file("%s.dat" % account.id)

	return dir.remove(path)
