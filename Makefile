#path = main.s

#run:
#	-@rm -rf Debug
#	-@mkdir Debug
#	-@nasm -f elf64 $(path) -o Debug/a.o -g
#	-@mold Debug/a.o -o Debug/a
#	-@qemu-x86_64 ./Debug/a
#	-@rm -rf Debug
#	-@echo "Process ended"

#build:
#	-@rm -rf Release
#	-@mkdir Release
#	-@yasm -f elf64 $(path) -o Release/a.o
#	-@mold Release/a.o -o Release/app
#	-@rm Release/a.o
#	-@echo "./Release/app"

#clean:
#	-@rm -rf Debug
#	-@rm -rf Release
#	-@echo "Debug and Release directories had removed"





# Define the path to the main assembly file
f = main.s
o = app
# Command to install YASM and Mold if not already installed
help:
	@echo "Requaried:"
	@echo "      yasm"
	@echo "      mold"
	@echo ""
	@echo "Arm Requaried:"
	@echo "      blink"
	@echo ""
	@echo "Examples List:"
	@echo "      make list"
	@echo ""
	@echo "Run File:"
	@echo "      make run f=<file_path>"
	@echo "   note: the path is ./main.s by default!"
	@echo ""
	@echo "Build File:"
	@echo "      make build f=<file_path> o=<outpu_ name>"
	@echo "   note: path is ./main.s by default!"
	@echo "   note: output in: ./release!"
	@echo ""
	@echo "Run Example:"
	@echo "      make run_ex f=<example_name>"
	@echo ""
	@echo "Clean Debug and Release:"
	@echo "      make clean"



# Print all examples
list:
	@for file in $(wildcard ./apps/*.*); do \
		echo $$(basename $$file .$(suffix $$file)); \
	done

run_ex:
	@make -s run f=./apps/$(f)


# Check the architecture and run the program
run:
	-@rm -rf debug
	-@mkdir debug
	-@yasm -f elf64 -g dwarf2 $(f) -o debug/a.o
	-@mold debug/a.o -o debug/a
	-@if [ "$(shell uname -m)" = "x86_64" ]; then \
		./debug/a; \
	else \
		blink ./debug/a; \
	fi
	-@rm -rf debug
	-@echo "Process ended"

# Command to build the program for release
build:
	-@rm -rf release
	-@mkdir release
	-@yasm -f elf64 $(f) -o release/a.o
	-@mold release/a.o -o release/app
	-@rm release/a.o
	-@echo "./release/app"



# Command to clean build artifacts
clean:
	-@rm -rf debug
	-@rm -rf release
	-@echo "Debug and Release directories have been removed"
