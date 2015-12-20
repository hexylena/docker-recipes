# node-dev environment

simple nodejs/npm environment for dev work because figuring out how to install nodejs is unpleasant


## Included stuff

- byobu (screen/tmux improvement)
- vim
    - with spf13-vim modules
- git


## Instructions

```console
$ docker build -t nodev .
$ docker run -it -p 8080:8080 -v `pwd`:/data nodev
```
