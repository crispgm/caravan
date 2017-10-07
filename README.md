# [Caravan](https://crispgm.github.io/caravan/)

[![Gem Version](https://badge.fury.io/rb/caravan.svg)](https://badge.fury.io/rb/caravan)
[![](https://api.travis-ci.org/crispgm/gsm.svg)](https://travis-ci.org/crispgm/caravan)
[![Code Climate](https://codeclimate.com/github/crispgm/caravan/badges/gpa.svg)](https://codeclimate.com/github/crispgm/caravan)
[![Test Coverage](https://codeclimate.com/github/crispgm/caravan/badges/coverage.svg)](https://codeclimate.com/github/crispgm/caravan/coverage)

Simple watcher and deployer.

The background is when you are developing in your local workspace and the program only runs in specific runtime. You have to setup by yourself to make the program run and debug on runtime folders or ,remote machines. Caravan is designed for solving such kind of problems by watching the file changes, and deploy them automatically to the its destination.

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
    -b, --debug                      Debug mode
        --version                    Show version
```

Example:

```
$ caravan -s /path/to/project/. -d /path/to/deploy -m shell
```

## Configuration

Generate default configuration:

```
$ cd /path/to/src
$ caravan init
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

## Plan

- [x] Basic watching and deploying
- [x] Exclude watching unwanted files
- [x] `caravan.yml` for project-specialized configuration
- [ ] Watch and deploy only the changed file instead of the whole folder
- [ ] Callback for deployment
- [ ] Multiple deployment configurations

## LICENSE

[MIT](/LICENSE)
