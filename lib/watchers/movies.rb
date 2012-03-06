require_relative './base.rb'

module Watchers

  class Movies < Base
    
    def initialize paths=[]
      watch paths do |paths|
        $logger.info "Movie change: #{paths.inspect}"
      end
    end
  end
end