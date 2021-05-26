# Notes



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


## HashTables VS MutableHashTables
A hash table consists of: a class type, a parent type, and a set of key-value pairs. The keys and values can be anything. The access functions below accept a key and return the corresponding value.

Main difference is that MutableHashTables are basically HashTables whose entries can be modified (changed, deleted, added).

We will be using HashTables because a user wouldn't want to modify a polynomial anyway. It is better to just make a new one. 