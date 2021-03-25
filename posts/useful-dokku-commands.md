---
title: Useful Dokku Commands
date: 2020-05-28 15:24:46
published: true
---

A micro post for commands that I usually look for, while using dokku.

## Create App

```bash
dokku apps:create <app-name>
```

## Database

```bash
sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git

dokku postgres:create <db-name>

dokku postgres:link <db-name> <app-name>

```

## Logs

```bash
dokku logs <app-name>

dokku logs <app-name> -t #to tail the logs

```

## SSL

```bash
sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git

dokku config:set --no-restart <app-name> DOKKU_LETSENCRYPT_EMAIL=<email>

dokku letsencrypt <app-name>
```

## Domain
```bash
dokku domains:add <app-name> <domain>
```

## Process Management

### Restart

```bash
dokku ps:restartall
dokku ps:restart <app-name>
```

```bash
### Rebuild from source
dokku ps:rebuildall
dokku ps:rebuild <app-nam>
```

## Deploy

```bash
git remote add dokku dokku@<host>:<app-name>

git push dokku master

or

git push dokku <local-branch>:master
```
