ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR

require "rubygems"

begin
  require "vendor/dependencies/lib/dependencies"
rescue LoadError
  require "dependencies"
end

require 'monk/glue'
require 'json'
require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-do-adapter'
require 'dm-sqlite-adapter'
require 'logger'
require 'haml'
require 'sinatra/content_for2'
require 'json/pure'


class Main < Monk::Glue
  set :app_file, __FILE__
  use Rack::Session::Cookie,
                      :key => 'rack.session',
                      :domain => 'foo.com',
                      :path => '/',
                      :expire_after => 2592000,
                      :secret => 'fWQjDWlJTbcC4N59'
  helpers Sinatra::ContentFor2
end



# Load all application files.
Dir[root_path("app/**/*.rb")].each do |file|
  require file
end

# Connect to sqlite3.
sqlite3_path = monk_settings(:sqlite3)[:database]
DataMapper::Logger.new('tmp/seatr-debug.log', :debug)
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/#{sqlite3_path}")

DataMapper.finalize
#DataMapper.auto_migrate!
DataMapper.auto_upgrade!

Main.run! if Main.run?
