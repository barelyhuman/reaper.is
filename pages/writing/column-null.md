---
title: COLUMN “” CONTAINS NULL VALUES | Postgres
date: 2020-02-18 19:24:41
published: true
---

I don't maintain migrations so I end having this error almost everytime I add a
new column that's not nullable.

Here's a few queries you can execute for this.

#### Integer

```sql
ALTER TABLE public.<tablename> ADD COLUMN <column_name> integer NOT NULL default 0;
```

#### String

```sql
ALTER TABLE public.<tablename> ADD COLUMN <column_name> VARCHAR NOT NULL default ' ';
```

#### Boolean

```sql
ALTER TABLE public.<tablename> ADD COLUMN <column_name> boolean NOT NULL default false;
```
