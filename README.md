# dotfiles

:bulb: replace `branch` with `macos` or `linux`
```
curl -fsSLo install.sh https://raw.githubusercontent.com/amoutaux/dotfiles/<branch>/install.sh
chmod +x install.sh
./install.sh
rm install.sh
```

### Generate Ctags
- For python projects: 
```
ctags -R --fields=+l --languages=python --python-kinds=-iv -f ./tags $(python -c "import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))")
```
