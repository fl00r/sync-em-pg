sync-em-pg
===========

Simple wrapper around [em-pg](https://github.com/prepor/em-pg) for [em-synchrony](https://github.com/igrigorik/em-synchrony). And [Sequel](http://sequel.rubyforge.org/) adapter.

You can also look on [green-em-pg](https://github.com/prepor/green-em-pg) for [Green](https://github.com/prepor/green).

Usage
-----

```ruby
gem "sync-em-pg"
```

```ruby
require "sync-em/pg"
EM.synchrony do
  db = Sync::EM::PG.new host: "localhost",
    port: 5432,
    dbname: "test",
    user: "postgres",
    password: "postgres"
    
  res = db.send_query "select * from test"

  puts res.inspect

  EM.stop
end
```

Sequel
------

```ruby
require "sync-em/pg/sequel"
EM.synchrony do
  url = "postgres://postgres:postgres@localhost:5432/test"
  db = Sequel.connect(url, pool_class: Sync::EM::PG::Sequel::ConnectionPool)

  puts db[:test].all.inspect

  EM.stop
end
```