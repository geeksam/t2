namespace :db do
  namespace :fixtures do

    desc 'Create YAML test fixtures from data in an existing database.
    Defaults to development database.  Set RAILS_ENV to override.'
    task :dump => :environment do
      sql  = "SELECT * FROM %s"
      skip_tables = ["schema_migrations"]
      ActiveRecord::Base.establish_connection(RAILS_ENV)
      tables = ENV['TABLES'].split(',') if ENV['TABLES']
      tables ||= (ActiveRecord::Base.connection.tables - skip_tables)

      fixtures_path = "#{RAILS_ROOT}/test/fixtures"
      FileUtils.mkdir_p fixtures_path
      tables.each do |table_name|
        i = "00000"
        File.open("#{fixtures_path}/#{table_name}.yml", 'w') do |file|
          hash = {}
          ActiveRecord::Base.connection.select_all(sql % table_name).each do |record|
            hash["#{table_name}_#{i.succ!}"] = record
          end
          file.write hash.to_yaml
        end
      end
    end
  end
end
