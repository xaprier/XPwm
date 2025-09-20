<h1 align="center">
  🚀 XPwm
</h1>

<p align="center">
  <a href="https://github.com/SFENX-Group/XPwm/blob/main/LICENSE" target="blank">
    <img src="https://img.shields.io/github/license/SFENX-Group/XPwm" alt="license" />
  </a>
</p>

<b>XPwm</b> is a password manager to keep your passwords in local as encrypted with a master password using OpenSSL AES-256 and Qt.

### 🛠️ Build Instructions for Linux/UNIX

Clone the repository to your directory

```sh
git clone --recursive https://github.com/SFENX-Group/XPwm.git
```

Enter the directory of the source code

```sh
cd XPwm/
```

Build the makefile with CMake, if you don't have cmake you have to install it.

```sh
cmake -G "Unix Makefiles" -B "build"
```

Than our Makefile is ready for build the source code. We have to access the directory of makefile and run make.

```sh
cd build && make -j$(nproc)
```

Than our compiled binary is ready for run in the directory of the makefile with the name "xpwm"
You can run the sample program with this command

```sh
./xpwm
```

### 🛠️ Install Instructions for Linux/UNIX

There is an install script named `install.sh` that can be used for Arch-based and newer Debian-based systems. If your system does not meet these requirements, you can try the AppImage file available in the releases section.

Clone the repository to your directory

```sh
git clone --recursive https://github.com/SFENX-Group/XPwm.git
```

Enter the directory of the source code

```sh
cd XPwm/
```

Execute bash script

```sh
./install.sh
```

You can search the application `Password Manager`

### 📚 Dependencies

- CMake(Building project)
- GCC/Clang(Compiler for building project)
- Qt(GUI and Core libraries, 5.15.2 and later)
- OpenSSL(Library for encryption, 1.1 and later)
- Git(Just for cloning repository)

### 📸 Screenshot 

![](https://raw.githubusercontent.com/SFENX-Group/XPwm/main/screenshot/login.png)
![](https://raw.githubusercontent.com/SFENX-Group/XPwm/main/screenshot/main.png)

### ✨ Contributors
<p align="center">
  <p align="center">
    <a href="https://github.com/xaprier/XPwm/graphs/contributors">
      <img src="https://contrib.rocks/image?repo=xaprier/XPwm" />
    </a>
  </p>
  <p align="center">
    Made with <a href="https://contrib.rocks">contributors-img</a>
  </p>
</p>
