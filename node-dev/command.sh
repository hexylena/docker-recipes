function nodev {
    docker run -it -v `pwd`:/data -v /home/$USER/.vimrc.local:/root/.vimrc.local -p 8080:8080  nodev
}
function nodev-sh {
    docker run -it -v `pwd`:/data -v /home/$USER/.vimrc.local:/root/.vimrc.local -p 8080:8080 --entrypoint=/bin/bash nodev
}
