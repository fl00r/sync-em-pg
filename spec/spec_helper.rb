ENV['BUNDLE_GEMFILE'] = File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup'
require 'sync-em/pg'

require 'logger'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'

logger = Logger.new nil

DB_CONFIG = {
  host: "localhost",
  port: 5432,
  dbname: "postgres",
  user: "postgres",
  password: "postgres",
}

EM::PG.logger = logger

DB_URL = "postgres://%s:%s@%s:%d/%s" % [DB_CONFIG[:user], DB_CONFIG[:password], DB_CONFIG[:host], DB_CONFIG[:port], DB_CONFIG[:dbname]]

MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new