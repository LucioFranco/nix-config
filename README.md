# My nix config

To deploy this config:

```
./bin/deploy <host> 
```

## WSL

Download nixos.wsl tarball from the releases page and run this in powershell:
```
wsl --import nixos C:\Users\lucio\nixos .\nixos.wsl --version 2
```

and you will need to also manually set these in your Windows Terminal settings:

```
"cursorShape": "filledBox",
"font": 
{
    "face": "FiraCode Nerd Font Mono",
    "size": 11.5,
    "weight": "normal"
},
"padding": 0,
"scrollbarState": "hidden",
```
