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
    sudo('aptitude install htop vim most screen rsync git curl sudo')

def vim():
    sudo("aptitude install vim ack exuberant-ctags git ruby rake")
    run("curl -Lo- https://raw.githubusercontent.com/carlhuda/janus/master/bootstrap.sh | bash")
    rsync_project(local_dir="vimrc.before",remote_dir="~/.vimrc.before",delete=True)
    rsync_project(local_dir="vimrc.after",remote_dir="~/.vimrc.after",delete=True)

def env():
    rsync_project(local_dir="bashrc",remote_dir="~/.bashrc",delete=True)
    rsync_project(local_dir="inputrc",remote_dir="~/.inputrc",delete=True)
    rsync_project(local_dir="motd",remote_dir="~/.motd",delete=True)
    rsync_project(local_dir="gitconfig",remote_dir="~/.gitconfig",delete=True)
    rsync_project(local_dir="htoprc",remote_dir="~/.htoprc",delete=True)

def env_srv():
    rsync_project(local_dir="bashrc",remote_dir="~/.bashrc",delete=True)
    rsync_project(local_dir="inputrc",remote_dir="~/.inputrc",delete=True)
    rsync_project(local_dir="gitconfig",remote_dir="~/.gitconfig",delete=True)
    rsync_project(local_dir="motd",remote_dir="~/.motd",delete=True)
    sed('~/.bashrc','$BLUE','$RED',backup='')
    sed('~/.bashrc','\$\{GREEN\}','${MAGENTA}',backup='')

def setup():
    execute(update)
    execute(upgrade)
    execute(package)
    execute(env)
    execute(vim)

def setup_srv():
    #execute(update)
    #execute(upgrade)
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
