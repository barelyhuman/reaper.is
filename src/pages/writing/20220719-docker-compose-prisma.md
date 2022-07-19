---
layout: ../../layouts/Page.astro
title: Docker Compose, Prisma and the M1
published: true
date: 19/07/2022
---

Pointers,

- Make sure you have `links` defined for the `app` service
- The `connect_timeout` is a necessary param for the connection string if you are on M1

Everything else is pretty much standard docker compose

```yaml
version: '3.9'

services:
  app:
    container_name: app
    build: .
    ports:
      - '4321:4321'
    depends_on:
      - db
    links:
      - db
    env_file:
      - .env
    environment:
      DATABASE_URL: 'postgres://postgres:password@db/scirque?connect_timeout=300'
  db:
    container_name: db
    image: postgres:13-alpine
    expose:
      - 5432
    environment:
      POSTGRES_PASSWORD: 'password'
      POSTGRES_DB: 'dbname'
    volumes:
      - pgdata1:/var/lib/postgresql/data

volumes:
  pgdata1: {}
```

This post is a simple note for me for future, since I ended up spending quite a bit of time researching as to why the prisma client wouldn't connect in the docker compose during migration commands but work when the application is run in the same composed container.
