namespace :db do
  desc 'Create, migrate, and seed the database'
  task :setup do
    %w[
      db:create
      db:migrate
      db:seed
    ].each {|t|
      puts "[Rake] #{t}"
      system "bundle exec rake #{t}"
    }
  end

  desc 'Drop and setup the database'
  task :reset do
    %w[
      db:drop
      db:setup
    ].each do |t|
      puts "[Rake] #{t}"
      system "bundle exec rake #{t}"
    end
  end

  desc 'Drop the database'
  task :drop => [:terminate] do
    opts = $db.opts.dup
    db = opts[:database]
    $db.disconnect

    opts[:database] = 'template1'
    $db = Sequel.connect(opts)
    $db.run "DROP DATABASE \"#{db}\";"
    $db.disconnect

    $db.opts[:database] = db
  end

  desc 'Create the database'
  task :create => [:'pakyow:prepare'] do
    opts = $db.opts.dup
    db = opts[:database]
    $db.disconnect

    opts[:database] = 'template1'
    $db = Sequel.connect(opts)
    $db.run "CREATE DATABASE \"#{db}\";"
    $db.disconnect

    $db.opts[:database] = db
  end

  desc 'Migrate the database'
  task :migrate, [:version] => [:'pakyow:prepare'] do |_, args|
    if version = args[:version]
      flags = "-M #{version}"
    end

    system "bundle exec sequel -m ./migrations #{$db.url} #{flags}"
  end

  desc 'Seed the database'
  task :seed => [:'pakyow:stage'] do
    require 'config/seeds'
  end

  # http://stackoverflow.com/questions/5108876/kill-a-postgresql-session-connection
  desc "Fix 'database is being accessed by other users'"
  task :terminate => [:'pakyow:prepare'] do
    unless $db.nil?
      begin
        $db.run <<-SQL
        SELECT
        pg_terminate_backend(pid)
        FROM
        pg_stat_activity
        WHERE
        -- don't kill my own connection!
        pid <> pg_backend_pid()
        -- don't kill the connections to other databases
        AND datname = '#{ENV['DATABASE_URL'].split("/").last}';
        SQL
      rescue Exception => e
        puts e
      end
    end
  end

  namespace :migration do
    task :create, [:name] do |_, args|
      if !name = args[:name]
        raise ArgumentError, 'Expected a migration name'
      end

      require 'fileutils'

      path = File.join('.', 'migrations', "#{Time.now.to_i}_#{name}.rb")
      FileUtils.touch(path)

      puts "Created migration: #{path}"
    end
  end
end
