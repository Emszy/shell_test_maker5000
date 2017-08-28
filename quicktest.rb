=begin 
this programs takes in a directory that contains test files for a program
 and makes an shell script executable that runs all test files as params to your program


example 

ruby quicktest.rb ./c_file path_to_tests file_extension


so:

	ruby quicktest.rb ./lem-in path_to_tests .map

will result in 3 step process

1.	creates testing.sh
2. inside looks like:
		 ./lem-in path_to_tests/test1.map
		 ./lem-in path_to_tests/test2.map
		 ./lem-in path_to_tests/test3.map
		 ./lem-in path_to_tests/test4.map
		 ./lem-in path_to_tests/test5.map

3. run with: 
	#sh testing.sh

warning may be more complicated than its worth... only time will tell


=end

current_dir = "./" #change if you want the .sh file somewhere else
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
