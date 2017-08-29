current_dir = "./" #change if you want the .sh file somewhere else
test_file_name = "testing.sh"

def save_file(test_file_path, file_extension)
	x = 0
	dir_names = []
	Dir.new(test_file_path).each { |file|
			if file.include? file_extension or file_extension == "*"
				if file[0] == '.'
					next
				end
					dir_names[x] = file
				x += 1
			end
		}
		return (dir_names)
end

def print_dir_names(dir_names)
	x = 0
	while x < dir_names.length
		puts dir_names[x]
		x += 1
	end
end

def put_to_file(dir_names, current_dir, test_file_name, executable, test_file_path, valgrind_bool)
	File.open("#{current_dir}#{test_file_name}",  'w')\
	{ \
		|file| 
			file.write("RED=\'\\033[0;31m\'\n")
			file.write("GREEN=\'\\033[0;32m\'\n")
			file.write("BLACK=\'\\033[0m\'\n")
			x = 0
			while x < dir_names.length
				file.write("echo #{dir_names[x]}\n")
				if dir_names[x].include? "err" or dir_names[x].include? "bad"
					file.write("echo ${RED}\n")
				else
					file.write("echo ${GREEN}\n")
				end
				if valgrind_bool.to_i == 1
					file.write("valgrind --tool=memcheck --leak-check=yes -v #{executable} #{test_file_path}/#{dir_names[x]}\n")
				elsif valgrind_bool.to_i >= 2
					file.write("valgrind --tool=memcheck --leak-check=yes --leak-check=full --show-leak-kinds=all-v #{executable} #{test_file_path}/#{dir_names[x]}\n")	
				else
					file.write("#{executable} #{test_file_path}/#{dir_names[x]}\n")
				end
				file.write("echo ${BLACK}\n")
			x += 1
		end			
	}
end

def start(current_dir, test_file_name)
	valgrind_bool = 0
	arg_len = ARGV.length
	if arg_len == 4
		valgrind_bool = ARGV[3]
		arg_len -= 1
	end
	if arg_len == 3
		dir_names = []
		executable = ARGV[0]
		test_file_path = ARGV[1]
		file_extension = ARGV[2]
		p file_extension
		dir_names = save_file(test_file_path, file_extension)		
		print_dir_names(dir_names)
		put_to_file(dir_names, current_dir, test_file_name, executable, test_file_path, valgrind_bool)
	else
		puts "USAGE:"
		puts "\truby quicktest.rb executable path/to/files .test_file_type"
		puts "ex:\truby quicktest.rb ./lem-in /tests .map"
	end
end

start(current_dir, test_file_name)
