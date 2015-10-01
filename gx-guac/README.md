# Galaxy Guacamole VNC GIE

- `docker build -t erasche/guacproc .`
- `cp -Rv galaxy_guacamole /path/to/galaxy/config/plugins/interactive_environments/guacamole/`
- Apply patch from https://github.com/galaxyproject/galaxy/commit/7767ab79af08e36fac148d5f9ab44b4ef362ebde
- Launch "Guacamole" on a text file
- Watch console...wait for things to come up.
- Login with guacadmin:guacadmin
- run `docker exec -it GUACAMOLE_IMAGE_ID env | grep VNC`, you'll need the TCP address for configuring the GIE in Guacamole's admin view
- Menu at top right -> add new:
    - name: gie-test
    - host: port from above VNC linked image
    - port: 5900
    - password: password
- hit space bar to get to bottom, save.
- top right menu, gie-test
- *MAGIC*
