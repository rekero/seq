# Migrate

migrate = lambda do |env, version|
  ENV['RACK_ENV'] = env
  require_relative 'db'
  require 'logger'
  Sequel.extension :migration
  DB.loggers << Logger.new($stdout) if DB.loggers.empty?
  Sequel::Migrator.apply(DB, 'migrate', version)
end

desc "Migrate test database to latest version"
task :test_up do
  migrate.call('test', nil)
end

desc "Migrate test database all the way down"
task :test_down do
  migrate.call('test', 0)
end

desc "Migrate test database all the way down and then back up"
task :test_bounce do
  migrate.call('test', 0)
  Sequel::Migrator.apply(DB, 'migrate')
end

desc "Migrate development database to latest version"
task :dev_up do
  migrate.call('development', nil)
end

desc "Migrate development database to all the way down"
task :dev_down do
  migrate.call('development', 0)
end

desc "Migrate development database all the way down and then back up"
task :dev_bounce do
  migrate.call('development', 0)
  Sequel::Migrator.apply(DB, 'migrate')
end

desc "Migrate production database to latest version"
task :prod_up do
  migrate.call('production', nil)
end

# Shell

irb = proc do |env|
  ENV['RACK_ENV'] = env
  trap('INT', "IGNORE")
  dir, base = File.split(FileUtils::RUBY)
  cmd = if base.sub!(/\Aruby/, 'irb')
    File.join(dir, base)
  else
    "#{FileUtils::RUBY} -S irb"
  end
  sh "#{cmd} -r ./models"
end

desc "Open irb shell in test mode"
task :test_irb do 
  irb.call('test')
end

desc "Open irb shell in development mode"
task :dev_irb do 
  irb.call('development')
end

desc "Open irb shell in production mode"
task :prod_irb do 
  irb.call('production')
end

# Specs

spec = proc do |type|
  desc "Run #{type} specs"
  task :"#{type}_spec" do
    sh "#{FileUtils::RUBY} -w spec/#{type}.rb"
  end

  desc "Run #{type} specs with coverage"
  task :"#{type}_spec_cov" do
    ENV['COVERAGE'] = type
    sh "#{FileUtils::RUBY} spec/#{type}.rb"
    ENV.delete('COVERAGE')
  end
end
spec.call('model')
spec.call('web')

desc "Run all specs"
task default: [:model_spec, :web_spec]

desc "Run all specs with coverage"
task spec_cov: [:model_spec_cov, :web_spec_cov]

# Other

desc "Annotate Sequel models"
task "annotate" do
  ENV['RACK_ENV'] = 'development'
  require_relative 'models'
  DB.loggers.clear
  require 'sequel/annotate'
  Sequel::Annotate.annotate(Dir['models/**/*.rb'])
end

desc "Fill data for postgres"
task "fill_data" do
  ENV['RACK_ENV'] = 'development'
  require_relative 'models'
  require './services/calculate_disbursement_service'
  require 'json'
  require 'time'
  DB.loggers.clear

  DB[:merchants].delete
  DB[:shoppers].delete
  DB[:orders].delete
  DB[:disbursements].delete

  merchants_file = File.read('./data/merchants.json')
  orders_file = File.read('./data/orders.json')
  shoppers_file = File.read('./data/shoppers.json')

  merchants_hash = JSON.parse(merchants_file)
  orders_hash = JSON.parse(orders_file)
  shoppers_hash = JSON.parse(shoppers_file)

  merchants_hash['RECORDS'].each do |record|
    DB[:merchants].insert(record)
  end
  
  orders_hash['RECORDS'].each do |record|
    DB[:orders].insert(
      record.merge(
        {
          'completed_at' => (record['completed_at'].empty? ? nil : DateTime.parse(record['completed_at'])),
          'created_at' => DateTime.parse(record['created_at'])
        }
      )
    )
  end

  shoppers_hash['RECORDS'].each do |record|
    DB[:shoppers].insert(record)
  end

  mondays = (DB[:orders].min(:completed_at).to_date..DB[:orders].max(:completed_at).to_date).to_a.select { |day| day.wday == 1 }
  mondays.each do |monday|
    CalculateDisbursementService.call(monday)
  end
end
