module Watchers
  class TvShows < Watcher
    def initialize
      watch '/tmp/watch/tv_shows' do |files|
        puts "TvShow change: #{files.inspect}"
      end
    end
  end
end