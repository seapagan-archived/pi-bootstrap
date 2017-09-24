#!/usr/bin/env bash
# this script will run as the default non-privileged user, so the 'sudo' password
# will be requested at the start.
#
# Currently script must be cloned to and run on the local PI, remote access will come later.

# save the path to this script for later use
THISPATH="$(dirname $(readlink -f "$0"))"
echo "We are running from : $THISPATH"

# remove the motd if exists, it annoys me!
if [ -f "/etc/motd" ] ; then
  sudo rm /etc/motd
fi

# ensure we have the latest packages
sudo apt update
sudo apt -y full-upgrade

# install a large set of libraries, dev headers and programs that will be needed by other installs.
sudo apt install -y build-essential libssl-dev libreadline-dev zlib1g-dev sqlite3 libsqlite3-dev libgtk2.0-0 libbz2-dev libxml2-dev libdb-dev gedit pcmanfm \
  libgdbm-dev tcl-dev tk-dev libtcl8.6 libtk8.6  libffi-dev libpcre3-dev mcrypt bison mercurial subversion subversion-tools gfortran liblzma-dev zip xorg-dev \
  software-properties-common gettext htop libcurl4-openssl-dev winbind libnss-winbind ccache

# need to append to the /etc/nsswitch.conf file to enable winbind if not already done ...
if ! grep -qc 'wins' /etc/nsswitch.conf ; then
  sudo sed -i '/hosts:/ s/$/ wins/' /etc/nsswitch.conf
fi

# install Git from source since the version in PI repo is usually behind ...
cd $HOME
wget https://www.kernel.org/pub/software/scm/git/git-2.14.1.tar.xz
tar -xvf git-2.14.1.tar.xz
cd git-2.14.1
./configure --prefix=/usr --with-gitconfig=/etc/gitconfig
make
sudo make install
cd $THISPATH

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
mkdir -p ~/.rbenv/plugins
git clone https://github.com/ianheggie/rbenv-binstubs.git ~/.rbenv/plugins/rbenv-binstubs
git clone https://github.com/sstephenson/rbenv-default-gems.git ~/.rbenv/plugins/rbenv-default-gems
git clone https://github.com/rbenv/rbenv-each.git ~/.rbenv/plugins/rbenv-each
git clone https://github.com/nabeo/rbenv-gem-migrate.git ~/.rbenv/plugins/rbenv-gem-migrate
git clone https://github.com/jf/rbenv-gemset.git ~/.rbenv/plugins/rbenv-gemset
git clone https://github.com/nicknovitski/rbenv-gem-update ~/.rbenv/plugins/rbenv-gem-update
git clone https://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update
git clone https://github.com/toy/rbenv-update-rubies.git ~/.rbenv/plugins/rbenv-update-rubies
git clone https://github.com/rkh/rbenv-whatis.git ~/.rbenv/plugins/rbenv-whatis
git clone https://github.com/yyuu/rbenv-ccache.git ~/.rbenv/plugins/rbenv-ccache

# set up a default-gems file for gems to install with each ruby...
echo $'bundler\nsass\nscss_lint\nrails\nrspec\nrspec-rails' > ~/.rbenv/default-gems
# set up .gemrc to avoid installing documentation for each gem...
echo "gem: --no-document" > ~/.gemrc
# install the required ruby version and set as default
rbenv install 2.4.2
rbenv global 2.4.2

# we need to erase 2 files temporarily (they will be regenerated) otherwise the installation will pause for overwrite confirmation
# These are the 'ri' and 'rdoc' scripts
rm ~/.rbenv/versions/2.4.2/bin/rdoc
rm ~/.rbenv/versions/2.4.2/bin/ri
# now update RubyGems and the default gems
gem update --system
gem update

# now install nvm, the latest LTS version of Node and the latest actual version of Node..
echo "## Setting up NVM (Node Version Manager) ##"
echo >> ~/.bashrc
echo "# Set up NVM" >> ~/.bashrc
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.4/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install --lts
nvm install node
# switch to the LTS version as default
nvm use --lts

# next install python (both 2.x and 3.x trees) using Pyenv
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
# install a couple of plugins...
git clone git://github.com/yyuu/pyenv-pip-migrate.git ~/.pyenv/plugins/pyenv-pip-migrate
git clone https://github.com/yyuu/pyenv-ccache.git $(pyenv root)/plugins/pyenv-ccache

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

pyenv install 2.7.14
pyenv install 3.6.2
# set so 'python' and 'python2' target 2.7.14 while 'python3' targets 3.6.2
pyenv global 2.7.14 3.6.2

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
# latest Perl version on Perlbrew seems to have install problems on PI, to investigate.
perlbrew install perl-5.26.1
perlbrew switch perl-5.26.1
perlbrew install-cpanm
# set up some cpan configuration
(echo y; echo o conf auto_commit 1; echo o conf yaml_module YAML::XS; echo o conf use_sqlite yes; echo o conf commit) | cpan
(echo o conf prerequisites_policy follow; echo o conf build_requires_install_policy yes) | cpan
(echo o conf colorize_output yes; echo o conf colorize_print bold white on_black; echo o conf colorize_warn bold red on_black; echo o conf colorize_debug green on_black) | cpan
# now install useful modules for CPAN...
cpanm Term::ReadLine::Perl --notest # we install this separately and with no tests so it will not timeout on unattended installs. Otherwise may timeout and crash the script.
cpanm CPAN Term::ReadKey YAML YAML::XS LWP CPAN::SQLite App::cpanoutdated Log::Log4perl XML::LibXML Text::Glob Net::Ping
# Upgrade any modules that need it...
cpan-outdated -p | cpanm

# copy a basic .gitconfig if we have it...
if [ -f "$THISPATH/support/.gitconfig" ] ; then
  cp $THISPATH/support/.gitconfig ~/.gitconfig
fi

echo
echo "Now would be a good time to reboot your PI!"
