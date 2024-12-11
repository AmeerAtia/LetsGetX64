path = main.s

run:
	-@rm -rf Debug
	-@mkdir Debug
	-@nasm -f elf64 $(path) -o Debug/a.o -g
	-@mold Debug/a.o -o Debug/a
	-@qemu-x86_64 ./Debug/a
	-@rm -rf Debug
	-@echo "Process ended"

build:
	-@rm -rf Release
	-@mkdir Release
	-@yasm -f elf64 $(path) -o Release/a.o
	-@mold Release/a.o -o Release/app
	-@rm Release/a.o
	-@echo "./Release/app"

clean:
	-@rm -rf Debug
	-@rm -rf Release
	-@echo "Debug and Release directories had removed"
