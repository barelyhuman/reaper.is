---

title: Setting up a personal git server
date: 24/09/2020
published: true
---

This post is not a blog write up and just consists of steps I went through to setup a git server on my home server ( Raspberry Pi, for now).

File content is available below.

1. Setup WIFI - Make sure it auto connects. (Default: Debian CLI Wifi)
2. Install NGINX,FastCGI and Setup gitweb config in `/etc/gitweb.conf`
3. Setup the default nginx to point to the gitweb config and `gitweb.cgi`
4. Setup Git Daemon to point to the `projects` directory and `--enable=receive-pack` as the additional parameter.
5. Restart services, nginx, fastcgi, git daemon.

Files.

etc/gitweb.conf

```sh
our $projectroot = "/home/pi/git-repos";
our @git_base_url_list = qw(git://192.168.31.162 pi@192.168.31.162:git-repos);
```

add this to the server listener in nginx

```sh
 location /gitweb.cgi {
           include fastcgi_params;
           gzip off;
           fastcgi_param   SCRIPT_FILENAME  /usr/share/gitweb/gitweb.cgi;
           fastcgi_param   GITWEB_CONFIG  /etc/gitweb.conf;
           fastcgi_pass    unix:/var/run/fcgiwrap.socket;
        }

        location / {
          root /usr/share/gitweb;
          index gitweb.cgi;
        }
```

Commands to create a repository.

```
git init --bare --shared <project-name>
cd <project-name>
touch git-daemon-export-ok
cp hooks/ppost-update.sample hooks/post-update
chomod a+x hooks/post-update
echo "Project Description" > description
```

Adios!
