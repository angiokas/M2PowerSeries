# Notes

## In case of Visual Studio Code error
Most likely, you have to reset wsl so you can type this in your terminal:
```
$ wsl --shutdown

```
Afterwards, just start a new WSL window in Visual Code and it should work. 

## Fixing `viewHelp`
Viewing MAcaulay2 documentation in a terminal is not recommended because of the way it shows up on the screen. This is why a better way to view documentation is to open the html files of the documentation in a browser. wsl originally comes with its own way of visualizing files, but the problem with wsl in Ubuntu 20.04 is that that the `wslview` command does not properly translate paths all the time, so we have to update it to the more modern wslu package which contains the new `wslview` command with the following code:

```
$ sudo add-apt-repository ppa:wslutilities/wslu
$ sudo apt install wslu
```

It might be required to set `WWWBROWSER` like so:
```
$ export WWWBROWSER=wslview
``` 

or save it for future sessions by running (basically go to `.bashrc` file and copy paste the above at the end):

```
$ echo "export WWWBROWSER=wslview" >> ~/.bashrc
```

Now if you go to the terminal or emacs, the Macualy2 command `viewHelp` should open a browser in your Windows parent operating system.

## Installing Jupyter
First make sure to update your package manager:
```
$ sudo apt update
```

Then install pip3:
```
$ sudo apt install python3-pip
```
Install jupyter using apt again:

```
$ sudo apt install jupyter
```

Makre sure you run this as root (Add sudo at the beginning), because it tries to put files in system diretories:
```
$ sudo pip3 install macaulay2-jupyter-kernel
$ sudo python3 -m m2_kernel.install
```

Then to make a new notebook, type:
```
jupyter notebook
```
If you fixed the browser to work on wsl, it should redirect you to your chosen browser in Windows. Then you should be able to make an M2 file in jupyter. 

## HashTables VS MutableHashTables
A hash table consists of: a class type, a parent type, and a set of key-value pairs. The keys and values can be anything. The access functions below accept a key and return the corresponding value.

Main difference is that MutableHashTables are basically HashTables whose entries can be modified (changed, deleted, added).

We will be using HashTables because a user wouldn't want to modify a polynomial anyway. It is better to just make a new one. 

## Some useful commands in Macaulay2
If you want to load a package, type this where "pkgname" is your package name (make sure you type it without the .m2 extension at the end!):
`
$ loadPackage "pkgname"
`
If you want to reload the package in the same session without restarting macaulay2:
`
$ loadPackage "pkgname", Reload => true
`
