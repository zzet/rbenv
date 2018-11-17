rbenv
========

Role for installing [rbenv](https://github.com/sstephenson/rbenv).

Role ready status
------------

[![Build Status](https://travis-ci.org/zzet/ansible-rbenv-role.png?branch=master)](https://travis-ci.org/zzet/ansible-rbenv-role)

Requirements
------------

none

Role Variables
--------------

Default variables are:

    rbenv:
      env: system
      version: v1.0.0
      default_ruby: 2.4.2
      rubies:
        - version: 2.4.2

    rbenv_clean_up: false

    rbenv_repo: "https://github.com/rbenv/rbenv.git"

    rbenv_plugins:
      - { name: "rbenv-vars",
          repo: "https://github.com/rbenv/rbenv-vars.git",
          version: "master" }

      - { name: "ruby-build",
          repo: "https://github.com/rbenv/ruby-build.git",
          version: "master" }

      - { name: "rbenv-default-gems",
          repo: "https://github.com/rbenv/rbenv-default-gems.git",
          version: "master" }

      - { name: "rbenv-installer",
          repo: "https://github.com/rbenv/rbenv-installer.git",
          version: "master" }

      - { name: "rbenv-update",
          repo: "https://github.com/rkh/rbenv-update.git",
          version: "master" }

      - { name: "rbenv-whatis",
          repo: "https://github.com/rkh/rbenv-whatis.git",
          version: "master" }

      - { name: "rbenv-use",
          repo: "https://github.com/rkh/rbenv-use.git",
          version: "master" }

    rbenv_root: "{% if rbenv.env == 'system' %}/usr/local/rbenv{% else %}$HOME/.rbenv{% endif %}"

    rbenv_users: []

    rbenv_extra_depends: []

Variables to control a system installation (these are not set by default):

    rbenv_owner: 'deploy'
    rbenv_group: 'deploy'

Description:

- ` rbenv.env ` - Type of rbenv installation. Allows 'system' or 'user' values
- ` rbenv.version ` - Version of rbenv to install (tag from [rbenv releases page](https://github.com/sstephenson/rbenv/releases))
- ` rbenv.default_ruby ` - Which ruby version to be set as global rbenv ruby.
- ` rbenv.rubies ` - Versions of ruby to install. This is an array of hashes. E.g. `[ { version: 2.4.2, env: { RUBY_CONFIGURE_OPTS="--enable-shared" } } ]`
- ` rbenv_clean_up ` - Delete all ruby versions not listed above. Default value is `false`
- ` rbenv_repo ` - Repository with source code of rbenv to install
- ` rbenv_plugins ` - Array of Hashes with information about plugins to install
- ` rbenv_root ` - Install path
- ` rbenv_users ` - Array of usernames for multiuser install. User must be present in the system
- ` rbenv_extra_depends` - Array of extra system packages to install before compiling rubies
- ` default_gems_file ` - This is Rbenv's plugin _rbenv-default-gems_. Sets the path to a default-gems file of your choice (_don't set it_ if you want to use the default file `files/default-gems`)
- ` rbenv_owner ` - The user  owning `rbenv_root` when `rbenv.env` is `system`
- ` rbenv_group ` - The group owning `rbenv_root` when `rbenv.env` is `system`
- ` rbenv_tmpdir ` - A temporary directory path used for artifacts when installing rubies. Defaults to system's `$TMPDIR`
- ` rbenv_set_vars ` - Set default vars `GEM_PATH=$GEM_PATH:$HOME/.gems` for 'user' env. Default value is `true`

Example:

    - hosts: web
      gather_facts: true # https://github.com/zzet/ansible-rbenv-role/issues/37
      vars:
        rbenv:
          env: user
          version: v0.4.0
          default_ruby: 2.0.0-p353
          rubies:
          - version: 2.0.0-p353
          - version: 2.2.4
            env:
              RUBY_CONFIGURE_OPTS: "--enable-shared"
          - version: 2.3.4
            env:
              RUBY_CONFIGURE_OPTS: "--enable-shared --with-jemalloc"
        rbenv_extra_depends:
          - libjemalloc1
          - libjemalloc-dev
      roles:
        - role: zzet.rbenv
          rbenv_users:
            - user

Dependencies
------------

none

License
-------

MIT

Author Information
------------------

[Andrew Kumanyaev](http://github.com/zzet)
