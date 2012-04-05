require_relative 'base'
require_relative 'video'

module Watchers

  class Movies < Base
    
    def initialize options={}
      watch(options['paths']) do |paths|
        $logger.info "Movie change: #{paths.inspect}"
      end
    end
  end
end