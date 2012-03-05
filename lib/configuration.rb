require 'singleton'
require 'pathname'
require 'yaml'

require_relative '../lib/init'

class Configuration

  include Singleton

  CONFIG_FILE = Pathname.new(File.expand_path(File.join($APP_ROOT, 'config', 'config.yml')))

  def self.get key
    unless @config
      if CONFIG_FILE.exist?
        @config = YAML.load_file(CONFIG_FILE)
      else
        $logger.error "Please ensure '#{CONFIG_FILE.expand_path.to_s}' exists"
        exit Errors::CONFIG_FILE_NOT_EXIST
      end      
    end
    @config[key]
  end
end