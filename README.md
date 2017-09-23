# Raspberry PI bootstrap script

This is an extension of my other project ["Bootstrap script for the Windows Subsytem for Linux (WSL)"][ubuntu-win-bootstrap]

This will be a set of scripts to provision a newly installed 'Headless' Raspberry PI with the following functionality :

* Updated to the latest package versions from Ubuntu upstream.
* Have the `build-essential` package installed plus all required support libraries to enable the below functionality to work.
* [`Sublime Text 3`][sublime] Editor installed as standard with `Package Control` and a number of useful packages.
* The Latest version of [`Git`][git] installed. A skeleton `.gitconfig` will be set up with a few aliases.
* The [`Ruby`][ruby] scripting language installed via [`Rbenv`][rbenv] with the current version of Rails installed as standard along with several other common gems.
* [`Node.js`][node] both the most recent LTS version and latest stable version via [`NVM`][nvm]. The LTS version is activated by default.
* The [`Python`][python] scripting language both the latest 2.7 and 3.x versions via [`Pyenv`][pyenv]
* Install the latest STABLE [`Perl`][perl] scripting language via [`Perlbrew`][perlbrew] with cpan and cpanm pre-installed and configured. Several PERL modules that make cpan easier are also pre-installed
* Enable resolution of WINS hostnames
* Install `GEdit` (Text editor) and `pcmanfm` (file manager). These are X-Window applications so you will need an x-server installed on your local computer

As a prerequisite, the PI to be provisioned should be running the [`Raspbian`][raspbian] Operating system, preferably the 'lite' version though the  full desktop version will work also.  
You will need to be able to connect to the PI over SSH since we are running Headless, so it will need to be plugged into a wired Ethernet connection that you can access. SSH needs to be enabled on your PI since this is disabled out of the box. See [this link][https://www.raspberrypi.org/documentation/remote-access/ssh/] for instructions (Section number 3).

**Please read all of this file before starting**

## Usage
The script is designed to be run either locally on the PI, or on a remote machine over SSH.

### Prepare the Raspberry PI

### Run the Script

#### Locally on the PI

#### Remotely over SSH

```
To be updated
```

## X-Server
To use the included version of `Sublime Text` or any other X-Windows programs we need to have an X-Server installed on whichever system, you are SSH'ing in from. Under Windows, I'd recommend installing [`VcXsrv`][vcxsrv]. This is a straightforward install and then run the `XLaunch` utility leaving everything at the default settings. We already set the `DISPLAY` environment variable to point to this as part of the bootstrap.  
Once that is installed and running you will be able to use any other X-Window based programs you wish to install - it is even possible to have the full UBUNTU graphical desktop running if that is your desire.

## Sublime Text 3
The bootstrap script will automatically install Sublime Text 3 with `Package Control` and a number of useful packages. These will properly be installed during the first and second times Sublime Text is opened. I recommend you run Sublime the first time,  wait a few seconds them close (this installs the `Package control` plug-in). Open it a second time and the rest of the packages will be installed. It may take a few minutes for the packages to install depending on your Internet speed so try not to close the program too soon.

#### Running sublime Text
```bash
$ subl
```

#### Packages installed are :
* All Autocomplete
* Babel
* Color Highlighter
* DocBlockr
* Emmet
* ExportHtml
* Git
* GitGutter
* HexViewer
* Markdown Preview
* MarkdownEditing
* Package Control
* SassBeautify
* SideBarEnhancements
* SublimeCodeIntel
* SublimeLinter
* SublimeREPL
* Terminal
* TrailingSpaces

The list of packages that are installed can be changed or added to by editing the  [Package Control.sublime-settings](support/Package%20Control.sublime-settings)

If you have a License for Sublime Text, copy that from your email into a file `support/License.sublime_license` before running the Bootstrap script, and it wil be properly installed to Sublime for you.

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
[ubuntu-win-bootstrap]: https://github.com/seapagan/ubuntu-win-bootstrap'
[raspbian]: https://www.raspberrypi.org/downloads/raspbian/
