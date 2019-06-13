echo 'Making symbolic links...'
for f in .??*; do
    [ "$f" = ".git" ] && continue
    [ "$f" = ".gitignore" ] && continue
    ln -snfv ~/dotfiles/"$f" ~/
done

