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
path = main.s
ex = 0.hello_world.s
# Command to install YASM and Mold if not already installed
help:
	@echo "Requaried: installing the next packages:"
	@echo "      yasm"
	@echo "      mold"
	@echo ""
	@echo "Arm Requaried: installing the next one:"
	@echo "      blink"
	@echo ""
	@echo "Examples: see examples list by running:"
	@echo "      make list"
	@echo ""
	@echo "Test Example: run any example by running:"
	@echo "      make test ex=<example_name>"
	@echo ""
	@echo "Run File: run any by running:"
	@echo "      make run path=<file_path>"
	@echo "   The path is ./main.s by default."
	@echo ""
	@echo "Build File: build any file by running:"
	@echo "      make build path=<file_path>"
	@echo "   The path is ./main.s by default."
	@echo "   Output will be in: ./release"



# Print all examples
list:
	@for file in $(wildcard ./apps/*.*); do \
		echo $$(basename $$file .$(suffix $$file)); \
	done

test:
	@make -s run path=./apps/$(ex)


# Check the architecture and run the program
run:
	-@rm -rf debug
	-@mkdir debug
	-@yasm -f elf64 -g dwarf2 $(path) -o debug/a.o
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
	-@yasm -f elf64 $(path) -o release/a.o
	-@mold release/a.o -o release/app
	-@rm release/a.o
	-@echo "./release/app"



# Command to clean build artifacts
clean:
	-@rm -rf debug
	-@rm -rf release
	-@echo "Debug and Release directories have been removed"
