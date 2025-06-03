The golang approach for versioning modules and submodules is described here https://go.dev/ref/mod#vcs-version

The main module will use semantic versioning e.g
v0.1.0
v0.1.1
...

The jenkins submodule dependancy will use prefixed tags
jenkins/0.1.0
jenkins/0.1.1
jenkins/0.1.2
...
