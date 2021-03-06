#!/bin/bash

echo
echo "DOTFILES"

for f in "zshrc" "vimrc" "gitconfig" "gitignore_global" "gitmessage.txt"; do
    DOTFILE="${HOME}/.${f}"
    if [[ -e "${DOTFILE}" && -h "${DOTFILE}" ]]; then
        echo "  ~/.${f} already exists"
    else
        echo "  Creating ~/.${f}"
        ln -s "${PWD}/${f}" "${HOME}/.${f}"
    fi
done

echo
echo "VIM COLORS"
if [ -d "${HOME}/.vim" ]; then 
    echo "  ~/.vim already exists"
else
    echo "  Creating ~/.vim"
    ln -s "${PWD}/vim" "${HOME}/.vim"
fi

echo
echo "DONE"
echo
