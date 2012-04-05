module Watchers
  class Video

    attr_reader :file, :options

    def initialize file, options={}
      @file = Pathname.new(file)
      @options = options
    end

    def process
    end

    def extensions
      %w{mpg mp4 m4v mov mkv divx xvid avi}
    end

    def is_video?
      regex = Regexp.new(/\.(?:#{extensions.join('|')})$/)
      file.to_s.downcase.match(regex) ? true : false
    end
  end
end