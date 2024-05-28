# MapProxy for Docker with MapServer support

![GitHub license](https://img.shields.io/github/license/justb4/docker-mapproxy-mapserver)
![GitHub release](https://img.shields.io/github/release/justb4/docker-mapproxy-mapserver.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/justb4/mapproxy-mapserver.svg)

This image extends the ["justb4" Docker Image for MapProxy](https://github.com/justb4/docker-mapproxy) with MapServer binaries (no MapServer CGI).
Reason is that MapProxy supports **directly calling the MapServer executable `mapserv`**, i.s.o. of accessing MapServer via OGC WMS. 
In my experience this is a huge performance gain in both MapProxy tile-seeding and tile-services. 

# Image Tags and Versions

Convention: `<mapproxy-version>-<mapserver-version-<buildnr>`, e.g. `justb4/mapproxy-mapserver:1.12.0-7.2.2-1`.

# How to setup 

The setup is similar as in the ["justb4" Docker Image for MapProxy README](https://github.com/justb4/docker-mapproxy/blob/master/README.md).
Only some extra config is needed for MapServer. Below an example for a `docker-compose` file.

``` 
services:

  mapproxy:

    image: justb4/mapproxy-mapserver:latest

    container_name: mapproxy

    environment:
      - MAPPROXY_PROCESSES=4
      - MAPPROXY_THREADS=2
      - UWSGI_EXTRA_OPTIONS=--disable-logging --max-worker-lifetime 30
      - MS_MAPFILE=/mapserver/mymapfile.map
      - DEBUG=0
      - MAPSERVER_CATCH_SEGV=1

    ports:
      - "8086:8080"

    volumes:
      - ./config/mapproxy:/mapproxy
      - ./config/mapserver:/mapserver
      - /var/mapproxy_cache:/mapproxy_cache

``` 

The in your MapProxy config YAML you can refer to the MapServer binary. First in the `sources:` section where you would normally configure backend WMS-es:

``` 
sources:
.
.

  labels_wms:
    type: mapserver
    req:
      map: /mapserver/mapserver.conf
      layers: labels
      format: image/png
      transparent: true
    coverage:
      bbox: [-20000.0,275000.0,300000.0,650000.0]
      srs: 'EPSG:28992'

```    

And the under `globals` indicate the location of the MapServer executable: 

``` 
globals:
  cache:
    base_dir: '/mapproxy_cache'

.
.
.
  # for calling MapServer directly
  mapserver:
    binary: /usr/bin/mapserv
    working_dir: /tmp

```

The [Mapproxy Documention](https://mapproxy.github.io/mapproxy/latest/sources.html#mapserver-label) shows some alternative config options.
