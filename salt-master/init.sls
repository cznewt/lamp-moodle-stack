salt-master:
  service:
    - running
    - watch:
      - file: /etc/salt/master

/etc/salt/master:
  file:
    - managed
    - source: salt://salt/etc/salt/master
    - require:
      - pkg: salt

/opt/salt/pillar:
  file.directory:
    - user: root
    - group: root
    - mode: 700
    - makedirs: True

https://github.com/cznewt/lamp-moodle-stack.git:
  git.latest:
    - target: /opt/salt/files
