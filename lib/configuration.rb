require 'singleton'
require 'pathname'
require 'yaml'

require_relative '../lib/init'

class Configuration

  include Singleton

  CONFIG_FILE = Pathname.new(File.expand_path(File.join($APP_ROOT, 'config', 'config.yml')))

  def self.providers
    get 'providers'
  end

  def self.watchers
    get 'watchers'
  end

  def self.get key
    unless @config
      if CONFIG_FILE.exist?
        @config = YAML.load_file(CONFIG_FILE)
      else
        puts "ERROR: Please ensure '#{CONFIG_FILE.expand_path.to_s}' exists"
        exit 1
      end      
    end
    @config[key]
  end
end