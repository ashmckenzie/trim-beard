require 'pathname'
require 'uri'

APP_ROOT = File.expand_path('../..', __FILE__)
APP_CONFIG_FILE = Pathname.new(File.expand_path(File.join(APP_ROOT, 'config', 'config.yml'), __FILE__))

if APP_CONFIG_FILE.exist?
  APP_CONFIG = YAML.load_file(APP_CONFIG_FILE)
else
  puts "ERROR: Please ensure '#{APP_CONFIG_FILE.expand_path.to_s}' exists"
  exit 1
end

Dir['lib/*/**'].each do |f|
  require File.join(APP_ROOT, f)
end