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
      ruby_version: 2.3.1

    rbenv_repo: "https://github.com/rbenv/rbenv.git"

    rbenv_plugins:
      - { name: "rbenv-vars",
          repo: "https://github.com/rbenv/rbenv-vars.git",
          version: "v1.2.0" }

      - { name: "ruby-build",
          repo: "https://github.com/rbenv/ruby-build.git",
          version: "v20160426" }

      - { name: "rbenv-default-gems",
          repo: "https://github.com/rbenv/rbenv-default-gems.git",
          version: "v1.0.0" }

      - { name: "rbenv-installer",
          repo: "https://github.com/rbenv/rbenv-installer.git",
          version: "bc21e7055dcc8f5f9bc66ce0c78cc9ae0c28cd7a" }

      - { name: "rbenv-update",
          repo: "https://github.com/rkh/rbenv-update.git",
          version: "1961fa180280bb50b64cbbffe6a5df7cf70f5e50" }

      - { name: "rbenv-whatis",
          repo: "https://github.com/rkh/rbenv-whatis.git",
          version: "v1.0.0" }

      - { name: "rbenv-use",
          repo: "https://github.com/rkh/rbenv-use.git",
          version: "v1.0.0" }

    rbenv_root: "{% if rbenv.env == 'system' %}/usr/local/rbenv{% else %}$HOME/.rbenv{% endif %}"

    rbenv_users: []

Variables to control a system installation (these are not set by default):

    rbenv_owner: 'deploy'
    rbenv_group: 'deploy'

Description:

- ` rbenv.env ` - Type of rbenv installation. Allows 'system' or 'user' values
- ` rbenv.version ` - Version of rbenv to install (tag from [rbenv releases page](https://github.com/sstephenson/rbenv/releases))
- ` rbenv.ruby_version ` - Version of ruby to install as global rbenv ruby
- ` rbenv_repo ` - Repository with source code of rbenv to install
- ` rbenv_plugins ` - Array of Hashes with information about plugins to install
- ` rbenv_root ` - Install path
- ` rbenv_users ` - Array of usernames for multiuser install. User must be present in the system
- ` default_gems_file ` - This is Rbenv's plugin _rbenv-default-gems_. Sets the path to a default-gems file of your choice (_don't set it_ if you want to use the default file `files/default-gems`)
- ` rbenv_owner ` - The user  owning `rbenv_root` when `rbenv.env` is `system`
- ` rbenv_group ` - The group owning `rbenv_root` when `rbenv.env` is `system`

Example:

    - hosts: web
      gather_facts: true # https://github.com/zzet/ansible-rbenv-role/issues/37
      vars:
        rbenv:
          env: user
          version: v0.4.0
          ruby_version: 2.0.0-p353
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

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/zzet/ansible-rbenv-role/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
