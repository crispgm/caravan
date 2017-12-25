# [Caravan](https://crispgm.github.io/caravan/)

[![Gem Version](https://badge.fury.io/rb/caravan.svg)](https://badge.fury.io/rb/caravan)
[![](https://api.travis-ci.org/crispgm/gsm.svg)](https://travis-ci.org/crispgm/caravan)
[![Code Climate](https://codeclimate.com/github/crispgm/caravan/badges/gpa.svg)](https://codeclimate.com/github/crispgm/caravan)
[![Test Coverage](https://codeclimate.com/github/crispgm/caravan/badges/coverage.svg)](https://codeclimate.com/github/crispgm/caravan/coverage)

Simple project files watcher and deployer.

The scenario is when we are developing in your local workspace and the program only runs in specific runtime environment, we have to setup by ourself to make the program run and debug on runtime folders, or remote machines. Caravan is the automation tool designed for solving such kind of problems by watching the file changes, and deploy them automatically to its destination.

![](/assets/civ-5-caravan.png)

This is the caravan in Sid Meier's Civilization V, which the project name originally comes from.

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

## Plan

- [x] Basic watching and deploying
- [x] Exclude watching unwanted files
- [x] `caravan.yml` for project-specialized configuration
- [ ] Watch and deploy only the changed file instead of the whole folder
- [x] Callbacks for deployment
    - [x] `after_create`
    - [x] `after_change`
    - [x] `before_deploy`
    - [x] `after_deploy`
    - [x] `before_destroy`
- [ ] Multiple deployment configurations

## LICENSE

[MIT](/LICENSE)
