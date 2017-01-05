# Slate

```

mix deps.get

mix run --no-halt

```

Install bourbon:
```gem install bourbon && bourbon install --path priv/static``

Install sass:
```gem install sass && neat install --path priv/static```


Compile the assets from /style over to /priv/static using
```sass style/main.css.scss priv/static/main.css```

# About the database, straight out of heroku:
```
Once Heroku Postgres has been added a DATABASE_URL or HEROKU_POSTGRESQL_COLOR_URL setting will be available in the app configuration and will contain the URL used to access the newly provisioned Heroku Postgres service. DATABASE_URL will be given to the database if it is the first one for the application, otherwise the HEROKU_POSTGRESQL_COLOR_URL will be created. This can be confirmed using the heroku config command.
```

# The admin pipeline I think I need:

* Only run https
* Only use the slate-blog.herokuapp.com
* Only authenticated (either basic or cookie)


Starting the DB:
pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
