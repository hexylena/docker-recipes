function ipr(){
    docker run \
        -v ~/Downloads/signalp-4.1/:/interproscan-5.7-48.0/bin/signalp/4.0/ \
        -v ~/Downloads/tmhmm-2.0c/:/interproscan-5.7-48.0/bin/tmhmm/2.0/ \
        -v ~/Downloads/phobius//:/interproscan-5.7-48.0/bin/phobius/1.01/ \
        interproscan $@
}
