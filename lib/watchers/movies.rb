require_relative './base.rb'

module Watchers
  class Movies < Base
    def initialize paths=[]
      watch paths do |path|
        $logger.info "Movie change: #{path.inspect}"
      end
    end
  end
end