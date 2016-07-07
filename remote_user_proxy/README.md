# Remote User Proxy image

Testing `REMOTE_USER` services can sometimes be complex if you do not have
infrastructure set up for it.

This proxy provides a convenient way to statically add a remote user username
and proxy your request to a backend service.

## Testing

A docker compose file is included for your convenience, launching this
(`docker-compose up`) will launch the proxy image as well as a netcat image
which simply listens on a port.

A single curl requests made to the proxy image will show up in the netcat image,
allowing you to see the headers which were made available.
