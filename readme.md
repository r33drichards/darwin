
```
nix run nix-darwin -- switch --refresh --flake github:r33drichards/darwin
nix run nix-darwin -- switch --refresh --flake .
nix --extra-experimental-features 'nix-command flakes'  run nix-darwin -- switch --refresh --flake .#rws-MacBook-Air                     
```

```
brew tap cfergeau/crc
brew install vfkit
```