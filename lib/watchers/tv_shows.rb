require_relative './base.rb'

module Watchers
  class TvShows < Base
    def initialize paths=[]
      watch paths do |path|
        $logger.info "TvShow change: #{path.inspect}"
      end
    end
  end
end