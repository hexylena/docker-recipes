#!/usr/bin/env python
import subprocess
import shutil
import re
import yaml
import sys
import os
import argparse


def main(package, version='default', image=None, dryrun=False, clone=False, quiet=False):
    parent_dir = os.path.dirname(os.path.abspath(__file__))
    build_dir = os.path.join(parent_dir, package, version)
    log_file = os.path.join(parent_dir, package, 'build.log')

    _store_new_version = False
    if not os.path.exists(build_dir):
        if os.path.exists(os.path.join(parent_dir, package, 'default')):
            build_dir = os.path.join(parent_dir, package, 'default')
            # In this case it's an "unknown" version, so we'll just be friendly
            # and serialize their yaml into a new versioned directory for them.
            _store_new_version = True
        else:
            if version == 'default':
                print "Default recipe for %s not found" % image
            else:
                print "Neither a default recipe, nor a recipe at version %s were found" % version
            sys.exit(4)

    if _store_new_version and clone:
        target = os.path.join(parent_dir, package, version)
        # Clone the default
        shutil.copytree(build_dir, target)
        # Update other variables.
        build_dir = target

    tentative_yaml_path = os.path.join(build_dir, 'build.yml')

    if not os.path.exists(tentative_yaml_path) and not os.path.isdir(tentative_yaml_path):
        print "No yaml file found at %s" % tentative_yaml_path
        sys.exit(3)

    with open(tentative_yaml_path, 'r') as handle:
        image_data = yaml.load(handle)

    DOCKER_TEMPLATE = """
FROM %(image)s
MAINTAINER Nare Coraor <nate@bx.psu.edu>

ENV DEBIAN_FRONTEND noninteractive
%(meta_env_string)s
%(env_string)s

VOLUME ["/host"]
# Pre-build packages
%(prebuild_packages)s

# Pre-build commands
%(prebuild_commands)s

ENTRYPOINT ["/bin/bash", "/host/build.sh"]
    """

    SCRIPT_TEMPLATE = """#!/bin/sh
urls="
{url_list}
"

mkdir -p /build/ && cd /build/;

( for url in $urls; do
    wget --quiet "$url" || false || exit
done)

{commands}"""

    template_values = {'image': 'ubuntu', 'prebuild_commands': "", 'env_string': ""}
    # ENVIRONMENT
    meta_env = {}
    docker_env = {}
    # If there's a 'meta' section, copy that into the environment, as we've
    # stored things like OS/package name/version there historically. Useful now
    # for the 'default' images which have a version hardcoded.
    if 'meta' in image_data:
        meta_env = image_data['meta']
        template_values['image'] = image_data['meta'].get('image', 'ubuntu')

    # If an image is sepecified, we overwrite the Dockerfile's FROM with that
    # image
    if image is not None:
        template_values['image'] = image
    # Additionally we store the actual image that the package is built with in
    # the environment, so it's accessible to build scripts.
    docker_env['image'] = template_values['image']

    # The docker environment (in the Dockerfile) is built from the image_data's
    # meta, and 'env' sections.
    if 'env' in image_data:
        docker_env.update(image_data['env'])
    template_values['env_string'] = '\n'.join(['ENV %s %s' % (key, docker_env[key])
                                               for key in docker_env])
    template_values['meta_env_string'] = '\n'.join(['ENV %s %s' % (key, meta_env[key])
                                                    for key in meta_env])

    # Version is often used to construct downloads, if it's set to "default",
    # then re-set it to the value in the default image's metadat
    if version == 'default':
        version = image_data['meta'].get('version', 'default')

    prebuild_packages = ['wget', 'openssl', 'ca-certificates', 'build-essential']
    if 'prebuild' in image_data and 'packages' in image_data['prebuild']:
        pkgs = image_data['prebuild']['packages']
        if isinstance(pkgs, str):
            prebuild_packages.extend(pkgs.strip().split())
        elif isinstance(pkgs, list):
            prebuild_packages.extend(pkgs)
        else:
            print "Unknown data type for /prebuild/packages, please use a space delimited string of package names, or a list of strings"
            sys.exit(5)

    template_values['prebuild_packages'] = "RUN apt-get -qq update && apt-get install --no-install-recommends -y %s" % ' '.join(prebuild_packages)

    if 'prebuild' in image_data and 'commands' in image_data['prebuild']:
        template_values['prebuild_commands'] = '\n'.join([
            'RUN %s' % command.strip()
            for command in image_data['prebuild']['commands']
        ])

    with open(os.path.join(build_dir, 'Dockerfile'), 'w') as dockerfile:
        dockerfile.write(DOCKER_TEMPLATE % template_values)

    with open(os.path.join(build_dir, 'build.sh'), 'w') as script:
        urls = image_data['build'].get('urls', [])
        commands = image_data['build'].get('commands', [])

        script.write(SCRIPT_TEMPLATE.format(url_list=' '.join(urls),
                                            commands='\n'.join(commands)))

    image_name = re.sub('[^A-Za-z0-9_]', '_', 'docker_build_%s_%s' % (package, template_values['image']))
    command = ['docker', 'build', '-t', image_name, '.']
    runcmd = ['docker', 'run', '--volume=%s/:/host/' % build_dir, '--env=pkg=%s' % package,
              '--env=version=%s' % version, image_name]
    if not dryrun:
        with open(log_file, 'w') as handle:
            execute(command, cwd=build_dir, log=handle, quiet=quiet)
            if not quiet:
                print ' '.join(runcmd)
            execute(runcmd, cwd=build_dir, log=handle, quiet=quiet)
    else:
        # I am *lazy* during debugging phase
        runcmd = runcmd[0:3] + ['-it', '--entrypoint=/bin/bash'] + runcmd[3:]
        print ' '.join(command)
        print ' '.join(runcmd)


def execute(command, cwd=None, log=None, quiet=False):
    popen = subprocess.Popen(command, stdout=subprocess.PIPE, cwd=cwd)
    for line in iter(popen.stdout.readline, b""):
        try:
            # Log output on demand, rather than just stdout

            # I don't know why I write these features when I only use them one
            # way, and it's ugly, non-reusable code in the first place
            if log is not None:
                log.write(line)

            if not quiet:
                print line,
        except KeyboardInterrupt:
            sys.exit()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Build things inside of docker')
    parser.add_argument('package', help='Name of the package, should be a folder')
    parser.add_argument('--version', help='Version of the package, should be a folder inside package, or "default" for versionless recipes',
                        default='default')
    parser.add_argument('--dryrun', action='store_true', help='Only generate files, does not build and run the image')
    parser.add_argument('--image', help='Build image against a different target OS, e.g. "debian:squeeze"')
    parser.add_argument('--clone', action='store_true', help='When building a default image with a different version, clone the build.yml and hardcode the version')
    parser.add_argument('--quiet', action='store_false', help='Be a bit quieter')
    args = parser.parse_args()
    main(**vars(args))
