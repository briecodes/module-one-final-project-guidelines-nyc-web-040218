require 'bundler'
Bundler.require
require_all 'app'
require 'asciiart'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'

ActiveRecord::Base.logger = nil
