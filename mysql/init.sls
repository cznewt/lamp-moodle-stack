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
{{ db.database }}_database:
  mysql_database:
    - present
    - name: {{ db.database }}
    - require:
      - service: mysql

{{ db.user }}_user:
  mysql_user:
    - present
    - name: {{ db.user }}
    - password: {{ db.password }}
    - require:
      - mysql_database.present: {{ db.database }}_database

{{ db.database }}_privileges:
  mysql_grants:
    - present
    - grant: all privileges
    - database: {{ db.database }}
    - user: {{ db.user }}
{#    - require:
      - mysql_user.present: {{ db.user }}_user #}
{%- endfor %}
