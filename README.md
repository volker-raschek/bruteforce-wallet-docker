# bruteforce-wallet-docker

[![Docker Pulls](https://img.shields.io/docker/pulls/volkerraschek/bruteforce-wallet)](https://hub.docker.com/r/volkerraschek/bruteforce-wallet)

This project contains all sources to build the container image `docker.io/volkerraschek/bruteforce-wallet`. The primary
goal of this project is to package the binary `bruteforce-wallet` as container image to provide the functionally for
CI/CD workflows. The source code of the binary can be found in the upstream project of
[bruteforce-wallet](https://github.com/glv2/bruteforce-wallet).

## Usage

The following example mounts the file `wallet.dat` located in the same directory where the command is executed into the
container filesystem as `/tmp/wallet.dat`. We also set some additional options, such as the password starting with `foo`
and ending with `bar`. In addition, we know that the password consists only of lower case letters and is between 4 and 8
characters long.

```bash
docker run \
  --rm \
  --volume wallet.dat:/tmp/wallet.dat \
  -b foo \
  -e bar \
  -s abcdefghijklmnopqrstuvwxyz \
  -l 4 \
  -m 8 \
    /tmp/wallet.dat
```
