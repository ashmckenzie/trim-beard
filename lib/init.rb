require 'singleton'

$APP_ROOT = File.expand_path('../..', __FILE__)

require_relative './logger'
require_relative './errors'
require_relative './configuration'

$logger = Logger.new