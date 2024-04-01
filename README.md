# *Makefile solution template*
Example of Makefiles for auto-building solutions.
Most of all, this template is targeted for auto resolving C/C++ source file dependencies during build process. Another goal is re-build only those sources (and their dependencies), that have been modified.

## Table of contents
0. [Table of contents](#table-of-contents)
1. [Software requirements for development](#software-requirements-for-development)
2. [Contacts and support](#contacts-and-support)
3. [How to use?](#how-to-use)  
   3.1. [Create solution](#create-solution)  
   3.2. [Build solution](#build-solution)

## Software requirements for development
* Git 2.25.1
* GNU Bash 5.0.17(1)-release
* GNU Make 4.4.1
* GNU coreutils 8.30

## Contacts and support
If you have any questions or suggestions, contact the developers:
* [Eugene Azimut e-mail](mailto:y.azimut@mail.ru "y.azimut@mail.ru") - y.azimut@mail.ru
* [Eugene Azimut on GitHub](https://github.com/yazimut "GitHub account")
* [Eugene Azimut on VK](https://vk.com/yazimut "vk.com - social network")

## How to use?
### Create solution
1. Place \"Makefile\", \".global.mk\" and \".template.mk\" (take them from this example) in the solution directory
2. Prepare your solution using 'make make-prepare';  
   2.1. **Note!** If you previously type projects names in Makefile:BuildingOrder variable and then execute 'make make-prepare', Make will create all marked projects
3. Create projects using 'make make-project ProjectName=MyNewProject'
4. Add project specific targets to the \"MyNewProject.mk\" (like in an example)

### Build solution
Now you can use Make to build your solution:
* Run 'make' in the solution directory. Make will build each your project with dependencies
* If you want to build only one project, use 'make MyNewProject' or directly run project makefile 'make -f MyNewProject.mk'
