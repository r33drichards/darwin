
```
nix run nix-darwin -- switch --refresh --flake github:r33drichards/darwin
nix run nix-darwin -- switch --refresh --flake .
sudo nix --extra-experimental-features 'nix-command flakes'  run nix-darwin -- switch  --refresh --flake .#rws-MacBook-Air                     
```

```
brew tap cfergeau/crc
brew install vfkit
```


## configure git auth 

1. [create a personal access token](https://github.com/settings/tokens/new?description=Nix%20Development&scopes=read:packages,repo)


2. configure nix.conf to use the token

```
mkdir -p ~/.config/nix
touch ~/.config/nix/nix.conf
echo "access-tokens = github.com=" >> ~/.config/nix/nix.conf
```
