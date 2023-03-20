---
title: Postgres ECONNREFUSED on 127.0.0.1
published: true
date: 30/09/2020
---

Postgres fails to start properly if there's an obsolete postmaster running and services fail to connect to it so just remove the pid **if it exists**
to make the service create a new process.

```sh
rm -f /usr/local/var/postgres/postmaster.pid
```
