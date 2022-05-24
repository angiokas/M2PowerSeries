# M2PowerSeries
Power series rings implementation in Macaulay2.

# Notes

## In case of Visual Studio Code error
Most likely, you have to reset wsl so you can type this in your terminal:
```
$ wsl --shutdown
```
Afterwards, just start a new WSL window in Visual Code and it should work. 

## Fixing `viewHelp`
Viewing Macaulay2 documentation in a terminal is not recommended because of the way it shows up on the screen. This is why a better way to view documentation is to open the html files of the documentation in a browser. wsl originally comes with its own way of visualizing files, but the problem with wsl in Ubuntu 20.04 is that that the `wslview` command does not properly translate paths all the time, so we have to update it to the more modern wslu package which contains the new `wslview` command with the following code:

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
Install Anaconda on wsl which will manage python versions and jupyter. This is recommended since this will allow the browser to work correctly since using jupyter separately caused some issues when using the browser, such as notebook files not opening. You can install anacdonda by following the instructions here: https://mas-dse.github.io/startup/anaconda-ubuntu-install/
or here:
https://docs.anaconda.com/anaconda/install/linux/
https://jupyter.org/install

After you install anacdonda on wsl server:

```
conda install -c conda-forge notebook
```

Update your package manager:
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

Now we need to install the Macaulay2 kernel for jupter to recodnize the Macaulay2 code and make notebooks using that kernel available. Make sure you run this as root (Add sudo at the beginning), because it tries to put files in system diretories:
```
$ sudo pip3 install macaulay2-jupyter-kernel
$ sudo python3 -m m2_kernel.install
```

Then to make a new notebook, type: 
```
$ jupyter notebook
```
If you fixed the browser to work on wsl, it should redirect you to your chosen browser in Windows. Then you should be able to make an M2 file in jupyter. 

You can also try using the VS code extension for jupyter: 
https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter

### For downloading Jupter notebooks as latex of pdf
In the beginning you might get an error if you don't have livetex installed. Jupyter should direct you to a website where you can get the code for installing the livetex for jupyter formatting which you should type in bash inside of your linux virtual machine:
```
sudo apt-get install texlive-xetex texlive-fonts-recommended texlive-plain-generic
```
Here is the website:
https://nbconvert.readthedocs.io/en/latest/install.html#installing-tex

You might also need pandoc:
```
sudo apt install pandoc
```


## Problems with overloading





## loading Packages
If you want to load a package, type this where "pkgname" is your package name (make sure you type it without the .m2 extension at the end!):

`
$ loadPackage "pkgname"
`

If you want to reload the package in the same session without restarting macaulay2

`
$ loadPackage "pkgname", Reload => true
`

## On Documentation
If you want to generate the html files of the documentation, then use the command `installPackage` and then restart Macaulay2:
```
installPackage "LazyPowerSeries"
```

Then if you want to view the documentation in a browser, use the command `viewHelp`:
```
viewHelp "LazyPowerSeries"
```
or if you prefer viewing the documentation in the terminal, use the command `help`:
```
help "LazyPowerSeries"
```

If you want to be safe when trying to update documentation, you can uninstall a package first, then load it and then install it:
```
uninstallPackage "LazyPowerSeries"
loadPackage "LazyPowerSeries"
installPackage "LazyPowerSeries"
```

If it gives you an error on using 'viewHelp' like this: 
error: package LazyPowerSeries is not installed on the prefixPath

Then use this command:
```makePackageIndex()```
which creates a file index.html in the ~/.Macaulay2 directory, containing links to the documentation for Macaulay2 and all installed packages. (Make sure to installPackage first before trying to use this command)

## On Testing
If you want to check tests, you should type the `check` command in macaulay like so:
```
check NewPowerSeries
```

## Checking for updates periodically
Will check for updates for everything
```
sudo apt update
```

This command will download new versions of everything
```
sudo apt upgrade
```

## On Debugging
Whenever you enter the debugger in case of encountering an error in your code ( which you might know if you see "ii" at the input), you can use it to figure out what is causing the error. If you want to exit out of it, you should type  `break`. 

If you were debugging by printing out useful information that is not needed for the final output of a method, but do not want to discard it completely, you can type `If debugLevel > 1 then ` before the prints so that if a user wishes to see that extra information such as values of internal variables, they have the option to. 