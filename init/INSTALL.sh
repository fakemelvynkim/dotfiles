#!/bin/sh
export DOTFILES_HOME_DIRECTORY=""

set_dotfiles_home_directory() {
    # main
    # Check if dotfiles home directory variable is set
    if [ -z "${DOTFILES_HOME_DIRECTORY}" ]; then
        DOTFILES_HOME_DIRECTORY="${HOME}/.dotfiles"
    fi
}

check_requirements() {
    # Die if dotfiles directory exists
    if [ -d "${DOTFILES_HOME_DIRECTORY}" ]; then
        echo "dotfiles exist in ${DOTFILES_HOME_DIRECTORY}"
        read -p "Do you wish to re-install dotfiles? [Y]es/[N]o: " prompt_yes_or_no
        case $prompt_yes_or_no in 
            [Yy]*) 
                echo "Removing existing dotfiles directory.."
                rm -rf "${DOTFILES_HOME_DIRECTORY}"
                echo "Cloning dotfiles.."
                wget --quiet --no-check-certificate https://raw.github.com/melvynkim/dotfiles/master/INSTALL.sh -O - | sh
                ;;
            [Nn]*)
                die_on_warning "dotfiles not installed."
                ;;
            *)
                die "Enter 'Yes' or 'No'"
                ;;
        esac
    fi
}

clone_dotfiles() {
    echo "Cloning dotfiles to ${DOTFILES_HOME_DIRECTORY}.."
    hash git >/dev/null 2>&1 && /usr/bin/env git clone --quiet --recursive "https://github.com/melvynkim/dotfiles" ${DOTFILES_HOME_DIRECTORY} || 
    die "git is not installed."    
}

add_symbolic_links() {
    # zsh
    ln -s "${DOTFILES_HOME_DIRECTORY}/zshrc.git" "${HOME}/.zsh"
    ln -s "${DOTFILES_HOME_DIRECTORY}/zshrc.git/.zshrc" "${HOME}/.zshrc"

    # vim
    ln -s "${DOTFILES_HOME_DIRECTORY}/vimrc.git" "${HOME}/.vim"
    ln -s "${DOTFILES_HOME_DIRECTORY}/vimrc.git/.vimrc" "${HOME}/.vimrc"

    # git
    ln -s "${DOTFILES_HOME_DIRECTORY}/git/.gitignore_global" "${HOME}/.gitignore_global"
    ln -s "${DOTFILES_HOME_DIRECTORY}/git/.gitconfig" "${HOME}/.gitconfig"
    ln -s "${DOTFILES_HOME_DIRECTORY}/git/.gitattributes" "${HOME}/.gitattributes"
}

die_on_warning() {
    echo "WARNING: $1"
    exit 2
    
}
die() {
    echo "ERROR: $1"
    echo "Report issues at http://github.com/melvynkim/dotfiles"
    exit 1
}


DOTFILES_HOME_DIRECTORY=$(set_dotfiles_home_directory)
check_requirements
clone_dotfiles
add_symbolic_links
