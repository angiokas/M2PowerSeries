# Lazy Power Series
Power series rings implementation in Macaulay2

# Notes

## Installing WSL 
Macaulay2 only runs on Linux so far and for windows users one way to bypass this is to use the software called WSL (Windows Subsystem for Linux) that runs linux on a virtual machine. This is included in windows so it's not a third party software you have to install. 

First to install wsl, make sure you open a power shell with administrative privilages and run the command
```
wsl --install
```
If it ran successfully, it should say 
```
The requested operation is successful. Changes will not be effective until the system is rebooted.
```
As it says, do not forget to reboot!

Then you have to make sure WSL is enabled on your windows by going to Windows Features.

To choose the linux system, you can go to the windows store and install the appropriate one. As an example, I always go for ubuntu and currently I have Ubuntu 20.04 LTS installed. Note that you need to have WSL installed and enabled before you are able to use this. 

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
installPackage NewPowerSeries
```

Then if you want to view the documentation in a browser, use the command `viewHelp`:
```
viewHelp NewPowerSeries
```
or if you prefer viewing the documentation in the terminal, use the command `help`:
```
help NewPowerSeries
```

If you want to be safe when trying to update documentation, you can uninstall a package first, then load it and then install it:
```
uninstallPackage NewPowerSeries
loadPackage NewPowerSeries
install NewPowerSeries
```

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
