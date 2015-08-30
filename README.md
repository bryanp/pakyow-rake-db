# pakyow-rake-db

Rake tasks for database maintenance with Pakyow + Sequel + Postgres. Adds the
following rake tasks to your project:

### db:drop

Drops the project's configured database.

### db:create

Drops the project's configured database.

### db:migrate[version]

Runs migrations against the project's configured database (all the way through
or to `version`).

### db:seed

Runs `config/seeds.rb` to load data into the project's configured database.

### db:setup

Runs `db:create`, `db:migrate`, and `db:seed`.

### db:reset

Runs `db:drop` and `db:setup`.

### db:migration:create[name]

Creates a new migration with provided `name`, automatically prefixed.

# Usage

Add `pakyow-rake-db` to your project's `Gemfile`.
