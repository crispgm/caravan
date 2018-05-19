---
layout: page
title: Documentation
---

Simple project files watcher and deployer.

The scenario is when we are developing in your local workspace and the program only runs in specific runtime environment, we have to setup by ourself to make the program run and debug on runtime folders, or remote machines. Caravan is the automation tool designed for solving such kind of problems by watching the file changes, and deploy them automatically to its destination.

![](/assets/civ-5-caravan.png)

This is the caravan in [Sid Meier's Civilization V](http://www.civilization5.com/), where the project name originally comes from.

## Installation

```
$ gem install caravan
```

## Usage

```
$ caravan --help

    -s, --source SOURCE_PATH         Source path
    -d, --dest DEST_PATH             Destination path
    -m, --mode DEPLOY_MODE           Deploy mode
    -i, --ignore IGNORE_FILES        Ignore files
    -o, --once                       Deploy for once
    -b, --debug                      Debug mode
    -l, --load YAML_FILE             YAML file (Default: ./caravan.yml)
        --version                    Show version
```

## Examples

Deploy to local directory:

```
$ caravan -s /path/to/project/. -d /path/to/deploy -m shell
```

Deploy to remote machines:

```
$ caravan -s /path/to/project/. -d user@remote_machines:/path/to/deploy -m rsync
```

Deploy only once:

```
$ caravan -s /path/to/project/. -d user@remote_machines:/path/to/deploy -m rsync --once
```

## Configuration

Generate default configuration:

```
$ cd /path/to/src
$ caravan --init
```

A `caravan.yml` will be generated as `/path/to/src/caravan.yml`. You may specify any options in command arguments except source path.

```
debug: false
deploy_mode: rsync_local
incremental: true
exclude:
- ".git"
- ".svn"
```

You may also write `src` and `dst` to `caravan.yml`. Hence, deployment made even easier.

```
$ caravan
```

`caravan.yml` can be named as you like. To load your own YAML file, use `--load`:

```
$ caravan --load my-caravan.yml
```

### Deploy Modes

* Shell
    * `cp` in local.
* Secure copy (scp)
    * `scp` to remote machines, _not recommended_.
* [rsync](https://rsync.samba.org/)
    * `rsync` to remote machines, which is the default and recommended mode because it is incremental. Thus, it performs much better.
* rsync_local
    * `rsync` in local.

## Plan

- [x] Basic watching and deploying
- [x] Exclude watching unwanted files
- [x] `caravan.yml` for project-specialized configuration
- [x] Callbacks for deployment
    - [x] `after_create`
    - [x] `after_change`
    - [x] `before_deploy`
    - [x] `after_deploy`
    - [x] `before_destroy`
- [ ] ~~Multiple deployment configurations~~
- [ ] Extension to deploy methods

## License

[MIT](/LICENSE)
