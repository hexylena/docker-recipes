# InterProScan from EMBL

This docker container contains InterProScan. Importantly, it lacks all of the data, which you will need to extract+mount yourself.

The data you can obtain from [the official documentation](https://code.google.com/p/interproscan/wiki/HowToDownload). You'll need to grab a copy of InterProScan as well as PANTHER, probably. Extract/deploy interpro just as you would normally, with the panther databases in the `data/` folder, and then point your docker mountpoint at them.

Additionally, volumes are provided to allow mounting of the academically licensed software that doesn't ship with InterProScan. If you do not provide these mountpoints, the software will be disabled during run. 

## Running

```bash
docker run \
    -v signalp-4.1/:/interproscan-5.7-48.0/bin/signalp/4.0/ \
    -v tmhmm-2.0c/:/interproscan-5.7-48.0/bin/tmhmm/2.0/ \
    -v phobius/:/interproscan-5.7-48.0/bin/phobius/1.01/ \
    -v data/:/interproscan-5.7-48.0/data \
    interproscan $@
```

## Environment Variables

- `DOCKER_JAVA_ARGS`, defaults to `-XX:+UseParallelGC -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseFastAccessorMethods -Xms128M -Xmx2048M`

## TODO

- More ENV variables to control configuration
- Mount point for local data (e.g., `/import/`)
