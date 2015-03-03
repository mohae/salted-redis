# salt/dev/redis/init.sls
# Installs redis based on the pillar settings.

{% if salt['pillar.get']('redis-server:enabled') %}
{% set version = salt['pillar.get']('redis-server:version', 'redis-stable') %}
{% set checksum_info = salt['pillar.get']('redis-checksums:redis-' + version + '-checksum', {}) %}
{% set algo = checksum_info.get('algo', 'sha1') %}
{% set checksum = checksum_info.get('checksum', '') %}
{% set loglevel = salt['pillar.get']('redis-server:loglevel', "notice") %}
{% set port = salt['pillar.get']('redis-server:port', 6379) %}
{% set root = salt['pillar.get']('redis-server:root', '/etc/redis') %}
{% set var = salt['pillar.get']('redis-server:var', '/etc/var') %}
{% set work = salt['pillar.get']('redis-server:work', '/tmp/redis') %}

redis-{{ version }}-dependencies:
  pkg.installed:
    - names:
    {% if grains['os_family'] == 'Debian' %}
      - build-essential
      - libxml2-dev
      - python-dev
    {% elif grains['os_family'] == 'RedHat' %}
      - make
      - libxml2-dev
      - python-devel
    {% endif %}

download-redis-{{ version }}:
  archive.extracted:
    - name: {{ work }}/
    - source: http://download.redis.io/releases/redis-{{ version }}.tar.gz
    - source_hash: {{ algo }}={{ checksum }}
    - archive_format: tar
#    - tar_options: zv
    - if_missing: {{ work }}/redis-{{ version }}
    - require:
      - pkg: redis-{{ version }}-dependencies

make-redis-{{ version }}:
  cmd.wait:
    - watch:
      - archive: download-redis-{{ version }}
    - cwd: {{ work }}/redis-{{ version }}
    - names:
      - make

redis-{{ version }}-executables:
  cmd.wait:
    - watch:
      - cmd: make-redis-{{ version }}
    - cwd: {{ work }}/redis-{{ version }}/src
    - names:
      - cp redis-server /usr/local/bin/
      - cp redis-cli /usr/local/bin/
      - cp redis-server /usr/local/bin/
      - cp redis-sentinel /usr/local/bin/
      - cp redis-benchmark /usr/local/bin/
      - cp redis-check-aof /usr/local/bin/
      - cp redis-check-dump /usr/local/bin/

config-redis-{{ version }}-executables:
  cmd.wait:
    - cwd: {{ work }}/redis-{{ version }}
    - names:
      - mkdir {{ root }}
    {% if root != var %}
      - mkdir {{ var }}
    {% endif %}
      - cp  utils/redis_init_script /etc/init.d/redis_{{ port }}
      - cp redis.conf {{ root }}/{{ port }}.conf
      - update-rc.d redis_{{ port }} defaults
    - watch:
      - cmd: redis-{{ version }}-executables

create-redis-{{ version }}-wd:
  cmd.wait:
    - names:
      - mkdir {{ var }}/{{ port }}
    - watch:
      - cmd: config-redis-{{ version }}-executables

redis-{{ version }}-config-daemonize:
  file.replace:
    - name: {{ root }}/{{ port }}.conf
    - pattern: "daemonize no"
    - repl: "daemonize yes"
    - require:
      - cmd: config-redis-{{ version }}-executables

redis-{{ version }}-config-pidfile:
  file.replace:
    - name: {{ root }}/{{ port }}.conf
    - pattern: "pidfile /var/run/redis.pid"
    - repl: "pidfile /var/run/redis_{{ port }}.pid"
    - require:
      - cmd: config-redis-{{ version }}-executables

redis-{{ version }}-config-port:
  file.replace:
    - name: {{ root }}/{{ port }}.conf
    - pattern: "port 6379"
    - repl: "port {{ port }}"
    - require:
      - cmd: config-redis-{{ version }}-executables

redis-{{ version }}-config-loglevel:
  file.replace:
    - name: {{ root }}/{{ port }}.conf
    - pattern: "loglevel notice"
    - repl: "loglevel {{ loglevel }}"
    - require:
      - cmd: config-redis-{{ version }}-executables

redis-{{ version }}-config-logfile:
  file.replace:
    - name: {{ root }}/{{ port }}.conf
    - pattern: "logfile \"\""
    - repl: "logfile \"/var/log/redis_{{ port }}.log\""
    - require:
      - cmd: config-redis-{{ version }}-executables

redis-{{ version }}-config-dir:
  file.replace:
    - name: {{ root }}/{{ port }}.conf
    - pattern: "dir ./"
    - repl: "dir {{ var }}/{{ port }}"
    - require:
      - cmd: config-redis-{{ version }}-executables

redis_{{ port }}:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - cmd: redis-{{ version }}-executables

{% endif %}  