module Watchers
  class Movies < Watcher
    def initialize
      watch '/tmp/watch/movies' do |files|
        puts "Movie change: #{files.inspect}"
      end
    end
  end
end