rbenv
========

Role for installing [rbenv](https://github.com/sstephenson/rbenv).

<!--

Role ready status
------------

[![Build Status](https://travis-ci.org/zzet/ansible-rbenv-role.png?branch=master)](https://travis-ci.org/zzet/ansible-rbenv-role)
-->

Requirements
------------

none

Role Variables
--------------

Default variables are:

```yml
    rbenv_install: system
    rbenv_version: v1.0.0
    rbenv_force_update: false

    rbenv_default_ruby: 2.4.2
    rbenv_rubies:
      - version: "{{ rbenv_default_ruby }}"

    rbenv_clean_up: false

    rbenv_repo: "https://github.com/rbenv/rbenv.git"

    rbenv_plugins:
      - ruby_build

    rbenv_plugin_vars:
      name: "rbenv-vars"
      repo: "https://github.com/rbenv/rbenv-vars.git"
      version: "master"
    rbenv_plugin_ruby_build:
      name: "ruby-build"
      repo: "https://github.com/rbenv/ruby-build.git"
      version: "master"
      force_update: true
    rbenv_plugin_default_gems:
      name: "rbenv-default-gems"
      repo: "https://github.com/rbenv/rbenv-default-gems.git"
      version: "master"
    rbenv_plugin_installer:
      name: "rbenv-installer"
      repo: "https://github.com/rbenv/rbenv-installer.git"
      version: "master"
    rbenv_plugin_update:
      name: "rbenv-update"
      repo: "https://github.com/rkh/rbenv-update.git"
      version: "master"
    rbenv_plugin_whatis:
      name: "rbenv-whatis"
      repo: "https://github.com/rkh/rbenv-whatis.git"
      version: "master"
    rbenv_plugin_use:
      name: "rbenv-use"
      repo: "https://github.com/rkh/rbenv-use.git"
      version: "master"

    rbenv_root: "{% if rbenv_install == 'system' %}/usr/local/rbenv\
                 {% else %}$HOME/.rbenv{% endif %}"

    rbenv_users: []

    rbenv_extra_depends: []
```

Variables to control a system installation (these are not set by default):

```yml
    rbenv_owner: 'deploy'
    rbenv_group: 'deploy'
```

Description:

- `rbenv_install` - Type of rbenv installation, `system` or `user`. Default is
  `system`.
- `rbenv_version` - Version of rbenv to install (tag from [rbenv releases
  page](https://github.com/sstephenson/rbenv/releases) or other valid git
  object ref)
- `rbenv_default_ruby` - Which ruby version to be set as global rbenv ruby.
- `rbenv_rubies` - Versions of ruby to install, see [Configuring
   rubies](#configuring-rubies) below.
- `rbenv_force_update` - Whether existing git checkout should be updated
- `rbenv_clean_up` - Delete all ruby versions not listed above.
   Default value is `false`
- `rbenv_repo` - Repository with source code of rbenv to install
- `rbenv_plugins` -  List of plugins to install. See [configuring
plugins](#configuring-plugins) below for details.
- `rbenv_plugin_{{ name }}` - Specification of a plugin. See [configuring
plugins](#configuring-plugins)
- `rbenv_root` - Install path
- `rbenv_users` - Array of usernames for multiuser install.
   User must be present in the system
- `rbenv_extra_depends` - Array of extra system packages to install before
   compiling rubies
- `rbenv_default_gems` - Name of default-gems file for rbenv-default-gems
   plugin (used only when `default_gems` is enabled in plugins)
- `rbenv_owner` - The user  owning `rbenv_root` when `rbenv_install` is `system`
- `rbenv_group` - The group owning `rbenv_root` when `rbenv_install` is `system`
- `rbenv_tmpdir` - A temporary directory path used for artifacts when
  installing rubies. Defaults to system's `$TMPDIR`
- `rbenv_set_vars` - Set default vars `GEM_PATH=$GEM_PATH:$HOME/.gems`
  for 'user' env. Default value is `true`

Configuring rubies
------------------

The smallest configuration possible to bring the ruby onto the target machine
is to specify the default ruby version:


```yaml
- hosts: ruby_hosts
  roles: timon.rbenv
  vars: { rbenv_default_ruby: 2.4.2 }
```

This will perform system-wide installation of `rbenv` (plus `ruby_build`
plugin), build ruby 2.4.2 and configures 2.4.2 to be the default ruby on the
host.

To install several ruby versions, you'll need to list them in `rbenv_rubies`
variable. This variable is expected to be a list of hashes that should have
at least `version` attribute. The default is to just include
`rbenv_default_ruby` version:

```yaml
rbenv_rubies:
  - version: '{{ rbenv_default_ruby }}'
```

Besides version, you could use`env` attribute to specify [additional
variables](https://github.com/rbenv/ruby-build#custom-build-configuration)
for custom build configuration.

```yaml
rbenv_rubies:
  - version: 2.4.2
    env: { RUBY_CONFIGURE_OPTS: "--enable-shared" }
```

Configuring plugins
-------------------

The list of plugins that should be installed in addition to base `rbenv`
distirbution is specified in `rbenv_plugins` variable. The definition for each
plugin listed in `rbenv_plugins` is loaded from `rbenv_plugin_{{plugin_name}}`
during role execution.

The default setting is to install
[ruby\_build](https://github.com/rbenv/ruby-build) plugin only.
This is what default plugin configuration looks like:

```yaml
rbenv_plugins:
  - ruby_build
rbenv_plugin_ruby_build:
  name: "ruby-build"
  repo: "https://github.com/rbenv/ruby-build.git"
  version: "master"
  force_update: true
```

You can opt-in for the following plugins installation, preserved from the
original `zzet.rbenv` role:

Name for `rbenv_plugins` | Plugin
-------------------------|---------
`rbenv_vars`   | [rbenv-vars](https://github.com/rbenv/rbenv-vars)
`default_gems` | [rbenv-default-gems](https://github.com/rbenv/rbenv-default-gems)
`installer`    | [rbenv-installer](https://github.com/rbenv/rbenv-installer)
`update`       | [rbenv-update](https://github.com/rkh/rbenv-update)
`whatis`       | [rbenv-whatis](https://github.com/rkh/rbenv-whatis)
`use`          | [rbenv-use](https://github.com/rkh/rbenv-use)

You can add your own plugins to the `rbenv_plugins` list, provided that you also
sepecify a plugin definition under `rbenv_plugin_{{plugin_name}}`.
Plugin definition should be a hash with keys `name`, `repo` (git url),
and `version` (tag or branch or otherwise valid git object ref).
Optional attribute `force_update` controls if git checkout should be performed
when the plugin appears to be installed.  The default value for `force_update`
attribute is set to match `rbenv_force_update` variable.

Example playbook
----------------

```yml
    - hosts: web
      gather_facts: true # https://github.com/zzet/ansible-rbenv-role/issues/37
      vars:
        rbenv_install: user
        rbenv_version: v0.4.0
        rbenv_default_ruby: 2.0.0-p353
        rbenv_rubies:
        - version: "{{ rbenv_default_ruby }}"
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
```

Dependencies
------------

none

License
-------

MIT

Author Information
------------------

[Andrew Kumanyaev](http://github.com/zzet)
