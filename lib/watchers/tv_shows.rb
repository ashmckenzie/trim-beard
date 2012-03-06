require_relative './base.rb'

module Watchers

  class TvShows < Base

    def initialize paths=[]
      watch paths do |paths|
        $logger.info "TvShow change: #{paths.inspect}"
        paths.each do |path|
          TvShow.new(path).process
        end
      end
    end
  end

  class TvShow < Video

    attr_reader :show_name, :season_number, :episode_number

    def process
      if is_video? && is_tv_show?
        ap self
      end
    end

    def is_tv_show?
      regex = Regexp.new(/^(.+)\.s(\d+)(?:e|x)(\d+).*\.(?:#{extensions.join('|')})$/)
      if m = file.basename.to_s.downcase.match(regex)
        @show_name = m[1]
        @season_number = m[2].sub(/^0+/, '')
        @episode_number = m[3].sub(/^0+/, '')
        true
      else
        false
      end
    end
  end    
end