from fabric.api import *
from fabric.contrib import *
from fabric.contrib.project import rsync_project
from fabric.contrib.files import sed

env.shell = "/bin/bash -c"

def update():
    while True:
        result = sudo("aptitude update")
        if result.return_code == 0:
            break

def upgrade():
    sudo("aptitude upgrade")

def package():
    sudo('aptitude install htop vim most screen rsync git curl')

def vim():
    sudo("aptitude install vim ack exuberant-ctags git ruby rake")
    run("curl -Lo- https://raw.githubusercontent.com/carlhuda/janus/master/bootstrap.sh | bash")
    rsync_project(local_dir="vimrc.before",remote_dir="~/.vimrc.before",delete=True)
    rsync_project(local_dir="vimrc.after",remote_dir="~/.vimrc.after",delete=True)

def ohmyzsh():
    run('sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"')
    rsync_project(local_dir="zshrc",remote_dir="~/.zshrc",delete=False)
    rsync_project(local_dir="ipod.zsh",remote_dir="~/.oh-my-zsh/custom/",delete=False)
    rsync_project(local_dir="ipygmalion.zsh-theme",remote_dir="~/.oh-my-zsh/custom/",delete=False)

def yakuake():
    sudo("aptitude install yakuake")
    rsync_project(local_dir="yakuakerc",remote_dir="~/.kde/share/config/yakuakerc",delete=False)
    run('mkdir -p ~/.config/autostart')
    rsync_project(local_dir="yakuake.desktop",remote_dir="~/.config/autostart/yakuake.desktop",delete=False)
    rsync_project(local_dir="Shell.profile",remote_dir=".kde/share/apps/konsole/Shell.profile",delete=False)

def env():
    rsync_project(local_dir="bashrc",remote_dir="~/.bashrc",delete=True)
    rsync_project(local_dir="inputrc",remote_dir="~/.inputrc",delete=True)
    rsync_project(local_dir="motd",remote_dir="~/.motd",delete=True)
    rsync_project(local_dir="gitconfig",remote_dir="~/.gitconfig",delete=True)
    rsync_project(local_dir="htoprc",remote_dir="~/.htoprc",delete=True)

def env_srv():
    rsync_project(local_dir="bashrc",remote_dir="~/.bashrc",delete=True)
    rsync_project(local_dir="inputrc",remote_dir="~/.inputrc",delete=True)
    rsync_project(local_dir="motd",remote_dir="~/.motd",delete=True)
    rsync_project(local_dir="gitconfig",remote_dir="~/.gitconfig",delete=True)
    rsync_project(local_dir="htoprc",remote_dir="~/.htoprc",delete=True)
    sed('~/.bashrc','$BLUE','$RED',backup='')
    sed('~/.bashrc','\$\{GREEN\}','${MAGENTA}',backup='')

def setup():
    execute(update)
    execute(upgrade)
    execute(package)
    execute(env)
    execute(vim)
    execute(ohmyzsh)

def setup_srv():
    execute(update)
    execute(upgrade)
    execute(package)
    execute(env_srv)
    execute(vim)

def remove():
    run("rm -f .bashrc")
    run("rm -f .inputrc")
    run("rm -f .motd")
    run("rm -f .gitconfig")
    run("rm -f .vimrc")
    run("rm -f .vimrc.after")
    run("rm -f .vimrc.before")
    run("rm -rf .vim")
    run("rm -rf .janus")
