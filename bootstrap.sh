#!/usr/bin/env bash
# this script will run as the default non-privileged user, so the 'sudo' password
# will be requested at the start.

# save the path to this script for later use
THISPATH="$(dirname $(readlink -f "$0"))"
echo "We are running from : $THISPATH"

# ensure we have the latest packages, including sublime text repos
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt -y full-upgrade


# install winbind and support lib to ping WINS hosts
sudo apt install -y winbind libnss-winbind
# need to append to the /etc/nsswitch.conf file to enable if not already done ...
if ! grep -qc 'wins' /etc/nsswitch.conf ; then
  sudo sed -i '/hosts:/ s/$/ wins/' /etc/nsswitch.conf
fi

# install a large set of libraries, dev headers and programs that will be needed by other installs.
sudo apt install -y build-essential libssl-dev libreadline-dev zlib1g-dev sqlite3 libsqlite3-dev libgtk2.0-0 libbz2-dev sublime-text libxml2-dev libdb-dev gedit pcmanfm

# set the DISPLAY variable to point to the XServer running on our Local PC
echo >> ~/.bashrc
echo "export DISPLAY=:0" >> ~/.bashrc

# start with rbenv and plugins installation
export PATH="$HOME/.rbenv/bin:$PATH"
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash
# install dynamic bash extension
cd ~/.rbenv && src/configure && make -C src
# add the rbenv setup to our profile, only if it is not already there
if ! grep -qc 'rbenv init' ~/.bashrc ; then
  echo "## Adding rbenv to .bashrc ##"
  echo >> ~/.bashrc
  echo "# Set up Rbenv" >> ~/.bashrc
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
fi
# run the above command locally so we can get rbenv to work on this provisioning shell
eval "$(rbenv init -)"
# install a set of useful plugins for rbenv...
mkdir -p /home/seapagan/.rbenv/plugins
git clone https://github.com/ianheggie/rbenv-binstubs.git ~/.rbenv/plugins/rbenv-binstubs
git clone https://github.com/sstephenson/rbenv-default-gems.git ~/.rbenv/plugins/rbenv-default-gems
git clone https://github.com/rbenv/rbenv-each.git ~/.rbenv/plugins/rbenv-each
git clone https://github.com/nabeo/rbenv-gem-migrate.git ~/.rbenv/plugins/rbenv-gem-migrate
git clone https://github.com/jf/rbenv-gemset.git ~/.rbenv/plugins/rbenv-gemset
git clone https://github.com/nicknovitski/rbenv-gem-update ~/.rbenv/plugins/rbenv-gem-update
git clone https://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update
git clone https://github.com/toy/rbenv-update-rubies.git ~/.rbenv/plugins/rbenv-update-rubies
git clone https://github.com/rkh/rbenv-whatis.git ~/.rbenv/plugins/rbenv-whatis
# set up a default-gems file for gems to install with each ruby...
echo $'bundler\nsass\nscss_lint\nrails\nrspec\nrspec-rails' > ~/.rbenv/default-gems
# set up .gemrc to avoid installing documentation for each gem...
echo "gem: --no-document" > ~/.gemrc
# install the required ruby version and set as default
rbenv install 2.4.1
rbenv global 2.4.1

# we need to erase 2 files temporarily (they will be regenerated) otherwise the installation will pause for overwrite confirmation
# These are the 'ri' and 'rdoc' scripts
rm ~/.rbenv/versions/2.4.1/bin/rdoc
rm ~/.rbenv/versions/2.4.1/bin/ri
# now update RubyGems and the default gems
gem update --system
gem update

# now install nvm, the latest LTS version of Node and the latest actual version of Node..
echo "## Setting up NVM (Node Version Manager) ##"
echo >> ~/.bashrc
echo "# Set up NVM" >> ~/.bashrc
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
nvm install --lts
nvm install node

# next install python (both 2.x and 3.x trees) using Pyenv
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

if ! grep -qc 'pyenv init' ~/.bashrc ; then
  echo "## Adding pyenv to .bashrc ##"
  echo >> ~/.bashrc
  echo "# Set up Pyenv" >> ~/.bashrc
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(pyenv init -)"' >> ~/.bashrc
fi
# run the above locally to use in this shell
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

pyenv install 2.7.13
pyenv install 3.6.1
# 'python' and 'python2.7' target 2.7.13 while 'python3.6' targets 3.6.1
pyenv global 2.7.13 3.6.1

# now to install Perl using Perlbrew...
\curl -L https://install.perlbrew.pl | bash
if ! grep -qc '~/perl5/perlbrew/etc/bashrc' ~/.bashrc ; then
  echo "## Adding Perlbrew to .bashrc ##"
  echo >> ~/.bashrc
  echo "# Set up Perlbrew" >> ~/.bashrc
  echo "source ~/perl5/perlbrew/etc/bashrc" >> ~/.bashrc
fi
# source perlbrew setup so we can use in this shell
source ~/perl5/perlbrew/etc/bashrc
# Currently the tests will fail under WSL so we dont run them. Needs further investigation.
perlbrew install perl-5.27.1 --notest
perlbrew switch perl-5.27.1
perlbrew install-cpanm
# set up some cpan configuration
(echo y; echo o conf auto_commit 1; echo o conf yaml_module YAML::XS; echo o conf use_sqlite yes; echo o conf commit) | cpan
(echo o conf prerequisites_policy follow; echo o conf build_requires_install_policy yes) | cpan
(echo o conf colorize_output yes; echo o conf colorize_print bold white on_black; echo o conf colorize_warn bold red on_black; echo o conf colorize_debug green on_black) | cpan
# now install useful modules for CPAN...
cpanm Term::ReadLine::Perl --notest # we install this separately and with no tests so it will not timeout on unattended installs. Otherwise may timeout and crash the script.
cpanm CPAN Term::ReadKey YAML YAML::XS LWP CPAN::SQLite App::cpanoutdated Log::Log4perl XML::LibXML Text::Glob
# Upgrade any modules that need it...
cpanm Net::Ping --force # confirm if this still needs forced!
cpan-outdated -p | cpanm

# copy a basic .gitconfig if we have it...
if [ -f "$THISPATH/support/.gitconfig" ] ; then
  cp $THISPATH/support/.gitconfig ~/.gitconfig
fi

# set up Sublime Text with Package control and a useful selection of default packages.
# You can edit the list of pre-installed packages in the file `./support/Package\ Control.sublime-settings`
# These packages will be installed when subl is first run
mkdir -p ~/.config/sublime-text-3/Installed\ Packages
mkdir -p ~/.config/sublime-text-3/Packages/User
mkdir -p ~/.config/sublime-text-3/Local
curl -o ~/.config/sublime-text-3/Installed\ Packages/Package\ Control.sublime-package https://packagecontrol.io/Package%20Control.sublime-package
cp $THISPATH/support/Package\ Control.sublime-settings ~/.config/sublime-text-3/Packages/User
# install the sublime license if it is found...
if [ -f "$THISPATH/support/License.sublime_license" ] ; then
  cp $THISPATH/support/License.sublime_license ~/.config/sublime-text-3/Local
fi
# it would also be very useful to pre-configure some Sublime Text default settings at this time
# TODO

echo
echo "Now would be a good time to reboot your PI!"
