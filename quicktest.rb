current_dir = "./" #change of you want the .sh file somewhere else
test_file_name = "testing.sh"

def save_file(test_file_path, file_extension)
	x = 0
	dir_names = []
	Dir.new(test_file_path).each { |file|
			if file.include? file_extension
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

def put_to_file(dir_names, current_dir, test_file_name, executable, test_file_path)
	File.open("#{current_dir}#{test_file_name}",  'w')\
	{ \
		|file| 
			file.write("RED=\'\\033[0;31m\'\n")
			file.write("GREEN=\'\\033[0;32m\'\n")
			file.write("BLACK=\'\\033[0m\'\n")
			x = 0
			while x < dir_names.length
				file.write("echo #{dir_names[x]}\n")
				if dir_names[x].include? "err"
					file.write("echo ${RED}\n")
				else
					file.write("echo ${GREEN}\n")
				end
				file.write("#{executable} #{test_file_path}/#{dir_names[x]}\n")
				file.write("echo ${BLACK}\n")
			x += 1
		end			
	}
end

def start(current_dir, test_file_name)
	if ARGV.length == 3
		dir_names = []
		executable = ARGV[0]
		test_file_path = ARGV[1]
		file_extension = ARGV[2]
		dir_names = save_file(test_file_path, file_extension)		
		print_dir_names(dir_names)
		put_to_file(dir_names, current_dir, test_file_name, executable, test_file_path)
	else
		puts "USAGE:"
		puts "\truby quicktest.rb executable path/to/files .test_file_type"
		puts "ex:\truby quicktest.rb ./lem-in /tests .map"
	end
end

start(current_dir, test_file_name)
