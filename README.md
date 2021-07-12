# Raspberry PI bootstrap script

## This script is currently UNMAINTAINED

I'll be updating my [linux-comfy-chair][lcc] project to support the PI and therefore make this repository obsolete. Kept for hostorical reasons.

This is an extension of my other project ["Bootstrap script for the Windows Subsystem for Linux (WSL)"][ubuntu-win-bootstrap]

__PLEASE NOTE this script is not yet fully converted from the original WSL version so will not work properly on the PI yet.__

This will be a set of scripts to provision a newly installed 'Headless' (No monitor or keyboard) Raspberry PI with the following functionality :

* Remove the default `pi` user, and create a new user with a password and sudo rights. This new user will then be used to install the local scripting languages etc.
* Updated to the latest package versions from Ubuntu upstream.
* Have the `build-essential` package installed plus all required support libraries to enable the below functionality to work.
* The Latest version of [`Git`][git] installed. A skeleton `.gitconfig` will be set up with a few aliases.
* The [`Ruby`][ruby] scripting language installed via [`Rbenv`][rbenv] with the current version of Rails installed as standard along with several other common gems.
* [`Node.js`][node] both the most recent LTS version and latest stable version via [`NVM`][nvm]. The LTS version is activated by default.
* The [`Python`][python] scripting language both the latest 2.7 and 3.x versions via [`Pyenv`][pyenv]
* Install the latest STABLE [`Perl`][perl] scripting language via [`Perlbrew`][perlbrew] with cpan and cpanm pre-installed and configured. Several PERL modules that make cpan easier are also pre-installed
* Enable resolution of WINS hostnames
* Install `GEdit` (Text editor) and `pcmanfm` (file manager). These are X-Window applications so you will need an x-server installed on your local computer

As a prerequisite, the PI to be provisioned should be running the [`Raspbian`][raspbian] Operating system, preferably the 'lite' version though the  full desktop version will work also.

The PI will need Internet access during the provisioning period.

You will need to be able to connect to the PI over SSH since we are running Headless, so it will need to be plugged into a wired Ethernet connection that you can access. SSH needs to be enabled on your PI since this is now disabled out of the box. See section three on [this link][pi-ssh] for instructions on how to do this.

**Please read all of this file before starting**

## Usage
The script is designed to be run locally on the PI. Future updates will be able to be run from a remote machine over SSH.

### Prepare the Raspberry PI

### Run the Script

#### Locally on the PI

#### Remotely over SSH

```
To be updated
```

## X-Server
To use any X-Windows programs we need to have an X-Server installed on whichever local system you are SSH'ing in from. Under Windows, I'd recommend installing [`VcXsrv`][vcxsrv]. This is a straightforward install and then run the `XLaunch` utility leaving everything at the default settings. We already set the `DISPLAY` environment variable to point to this as part of the bootstrap.  
Once that is installed and running you will be able to use any other X-Window based programs you wish to install - it is even possible to have the full UBUNTU graphical desktop running if that is your desire.

## Other Utilities
There are several other useful utilities installed, and the list is growing.
#### GEdit (Text Editor)
A nice basic text editor when you don't need all the functionality of Sublime Text.
```
$ gedit
```
#### PCManFM (File Manager)
A useful file manager to export and maintain the WSL file system. Especially since you should NEVER create, edit or delete files within the WSL structure using any Windows tool.
```
$ pcmanfm
```

## To-Do

* More robust fall-over on already configured systems. If Rbenv etc are already installed then ignore installing that part
* Split each different section out to it's own file for clarity

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[sublime]: https://www.sublimetext.com/
[git]: https://git-scm.com
[ruby]: https://www.ruby-lang.org
[rbenv]: https://github.com/rbenv/rbenv
[node]: https://nodejs.org
[nvm]: https://github.com/creationix/nvm
[python]: https://www.python.org/
[pyenv]: https://github.com/pyenv/pyenv
[perl]: https://www.perl.org/
[perlbrew]: https://perlbrew.pl/
[vcxsrv]: https://sourceforge.net/projects/vcxsrv/
[ubuntu-win-bootstrap]: https://github.com/seapagan/ubuntu-win-bootstrap
[raspbian]: https://www.raspberrypi.org/downloads/raspbian/
[pi-ssh]: https://www.raspberrypi.org/documentation/remote-access/ssh/
[lcc]: https://github.com/seapagan/linux-comfy-chair
