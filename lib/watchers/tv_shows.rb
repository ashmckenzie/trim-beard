require_relative 'base'
require_relative 'video'

module Watchers

  class TvShows < Base

    def initialize options={}
      jobs = []

      watch(options['paths']) do |paths|

        $logger.debug "TvShow change: #{paths.inspect}"

        paths.each do |path|
          jobs << Thread.new { TvShow.new(path, options) }
        end

        jobs.each { |x| x.join }
      end
    end
  end

  class TvShow < Video

    attr_reader :show_name, :season_number, :episode_number

    def initialize file, options
      super
      if is_video? && is_tv_show?
        $logger.info "TvShow found: #{show_name} (S#{season_number}E#{episode_number})"
        # ap self
        move
      end
    end

    def is_tv_show?
      regex = Regexp.new(/^(.+)\.s(\d+)(?:e|x)(\d+).*\.(?:#{extensions.join('|')})$/)
      if m = file.basename.to_s.downcase.match(regex)
        @show_name = clean_show_name(m[1])
        @season_number = m[2].sub(/^0+/, '')
        @episode_number = m[3].sub(/^0+/, '')
        true
      else
        false
      end
    end

    private

    def clean_show_name show_name
      show_name.gsub(/\./, ' ').split(/ /).collect { |x| x.capitalize }.join(' ')
    end

    def move
      location = new_location
      $logger.debug "TvShow: Moving '#{file}' '#{location}'"
      FileUtils.mkdir_p location.dirname
      FileUtils.copy file, location
    end

    def new_file_name
      Pathname.new("#{formatted_show_name}.S#{'%02d' % season_number}E#{'%02d' % episode_number}.#{title}#{file.basename.extname}")
    end

    def formatted_show_name
      show_name.gsub(/ /, '.')
    end

    def formatted_season_number
      "Season #{season_number}"
    end

    def title
      'Some.Title'
    end

    def new_location
      Pathname.new(File.join([ options['move_location'], show_name, formatted_season_number, new_file_name ]))
    end
  end
end