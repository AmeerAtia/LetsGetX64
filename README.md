# LetsGetX64

Welcome to **LetsGetX64**! This project is designed to help programmers learn Assembly (ASM) programming with practical examples. Whether you're a beginner or someone who wants to refine their skills, this project is a great resource to start your journey into low-level programming.

## Table of Contents
1. [Installation](#installation)
2. [How to Learn ASM with LetsGetX64](#how-to-learn-asm-with-letsgetx64)
3. [Project Roadmap](#project-roadmap)
4. [Contributing](#contributing)
5. [License](#license)

## Installation

To get started with **LetsGetX64**, follow the steps below to download and set up the project on your local machine.

### 1. Clone the Repository
First, clone the repository to your local machine using Git. Open a terminal and run the following command:

```bash
git clone https://github.com/AmeerAtia/LetsGetX64
```

### 2. Install Dependencies

There are external dependencies required to run the examples in this project. However, you will need an assembler like YASM and a linker like Mold (and blink to run AMD64 on arm CPUs) to assemble and run the examples.

You can install these tools using the following commands:

```bash
# for arch:
sudo pacman -S yasm mold
# for arm
sudo pacman -S yasm mold blink

# for termux:
pkg install yasm mold blink

# for windows and mac I cant help you, but you should install mold and yasm(and blink for arm)
```

### 3. Assemble and Run Examples

Navigate to the repo folder, get help. by following these steps:
```
cd LetsGetX64
make help
```

## How to Learn ASM with LetsGetX64

The LetsGetX64 project contains a collection of practical examples to help you learn Assembly. Here's how you can get the most out of the project:

1. Start with Basic Examples: Begin by reviewing the simplest example files in the repository, which cover topics like basic arithmetic, system calls, and printing to the screen.


2. Move on to More Complex Examples: Once you're comfortable with basic concepts, try exploring more advanced topics such as memory management, loops, and conditional statements.


3. Experiment: Modify existing examples or write your own to understand how the low-level code interacts with the system. This hands-on approach will accelerate your learning.


4. Use External Resources: If you're new to Assembly, consult external resources such as:

Introduction to x64 Assembly

Linux Assembly HOWTO

The Art of Assembly Language



5. Practice: ASM can be challenging, but with consistent practice and reading, you'll become proficient.



## Project Roadmap

The LetsGetX64 project will continue to evolve with new features and learning materials. Here's what we plan to work on:

### Phase 1. Basic Examples

- [x] 1.1. Simple arithmetic operations

- [x] 1.2. Printing text to the console

- [x] 1.3. System calls (exit, print, etc.)


### Phase 2. Intermediate Examples

- [ ] 2.1. Working with variables and memory

- [ ] 2.2. Creating functions in Assembly

- [ ] 2.3. Handling user input


### Phase 3. Advanced Topics

- [ ] 3.1. Writing Assembly programs that interact with files

- [ ] 3.2. Advanced system calls

- [ ] 3.3. Optimizing assembly code for performance

- [ ] 3.4. Creating a small shell in Assembly


### Phase 4. Educational Resources

- [ ] Creating video tutorials

- [ ] Writing blog posts and guides for beginners

- [ ] Community-driven challenges and projects


### Ongoing Maintenance

- [ ] Bug fixes

- [ ] Optimizing example code

- [ ] Keeping up with modern x64 architecture changes


## Contributing

Contributions to LetsGetX64 are welcome! If you'd like to help improve the project, please follow these steps:

1. Fork the repository.


2. Create a new branch (git checkout -b feature-branch).


3. Make your changes and commit them (git commit -am 'Add new feature').


4. Push to your branch (git push origin feature-branch).


5. Open a pull request.



Please ensure that any changes you make follow the project's coding standards and that they add value to the learning experience.

## License

This project is licensed under the MIT License - see the LICENSE file for details.


---

Happy coding, and enjoy learning Assembly with LetsGetX64!

