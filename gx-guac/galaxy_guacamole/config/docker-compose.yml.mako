external:
    image: erasche/gaucproc
    links:
        - guacamole
    ports:
        - "80"
    environment:
        % for env_var in env:
        ${env_var}: ${env[env_var]}
        % endfor

guacamole:
    image: glyptodon/guacamole
    environment:
        POSTGRES_DATABASE: postgres
        POSTGRES_USER: postgres
        POSTGRES_PASSWORD: password
        % for env_var in env:
        ${env_var}: ${env[env_var]}
        % endfor
    links:
        - postgres
        - guacd
        - vnc

guacd:
    image: glyptodon/guacd

postgres:
    image: postgres
    environment:
        POSTGRES_PASSWORD: password
    volumes:
        - ./initdb.sql:/docker-entrypoint-initdb.d/initdb.sql

vnc:
    image: sidirius/docker-lxde-vnc
    environment:
        passwd: "password"
