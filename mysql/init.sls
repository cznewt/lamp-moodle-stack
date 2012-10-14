python-mysqldb:
    pkg:
        - installed

/etc/mysql/my.cnf:
  file.managed:
    - source: salt://mysql/etc/mysql/my.cnf
    - mode: 644

mysql-server-{{ pillar['mysql-version'] }}:
  pkg:
    - installed
  service.running:
   - name: mysql
   - watch:
     - pkg: python-mysqldb
     - file: /etc/mysql/my.cnf

{%- for db in pillar['mysql-databases'] %}
{#
{{ db.database }}_database:
  mysql_database.present:
    - name: {{ db.database }}
  mysql_user.present:
    - name: {{ db.user }}
    - password: "{{ db.password }}"
  mysql_grants.present:
    - database: {{ db.database }}.*
    - grant: ALL PRIVILEGES
    - user: {{ db.user }}
  require:
    - pkg: python-mysqldb
    - service: mysql
#}
{{ db.database }}_database_create:
  module.run:
  - name: mysql.query
  - database: {{ db.database }}
  - query: "CREATE DATABASE IF NOT EXISTS {{ db.database }} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"

{{ db.database }}_database_unicode:
  module.run:
  - name: mysql.query
  - database: {{ db.database }}
  - query: "ALTER DATABASE {{ db.database }} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"

{{ db.database }}_database_grants:
  module.run:
  - name: mysql.query
  - database: {{ db.database }}
  - query: "GRANT ALL PRIVILEGES ON {{ db.database }}.* TO {{ db.user }} @'%' IDENTIFIED BY '{{ db.password }}';"
{%- endfor %}
