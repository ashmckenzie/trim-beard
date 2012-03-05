module Providers
  module NzbMatrix

    class Options

      include Singleton

      def self.setup options={}
        @options = options
        raise Exceptions::CredentialsMissing.new('Username not set') unless options['credentials']['username']  
        raise Exceptions::CredentialsMissing.new('API key not set') unless options['credentials']['api_key']
      end

      def self.get key
        @options[key]
      end
    end

    class Search

      SEARCH_URL = "http://api.nzbmatrix.com/v1.1/search.php?search=%s&catid=%s&username=%s&apikey=%s"
      CATEGORIES = {
        'movie' => 'movies-all',
        'tv' => 'tv-all'
      }

      def initialize query, category, download, options={}
        Options.setup(options)
        credentials = Options.get('credentials')

        begin
          url = URI.escape(sprintf(SEARCH_URL, query, CATEGORIES[category], credentials['username'], credentials['api_key']))
          $logger.debug "url=[#{url}]"
          #response = Response.new(RestClient.get(url))
          response = Response.new(File.new('./tmp/zoolander.data').readlines.join("\n"))
        rescue SocketError => e
        end

        matches = response.items.select do |item|
          item.category =~ /Xvid/
        end.sort do |x, y| 
          y.hits.to_i <=> x.hits.to_i
        end

        if download
          matches.first.download
        else
          # TODO: Interactive choice if not --download
          matches.each_with_index do |item, i|
            puts "#{i+1}. #{item.nzbname}, #{item.size.to_f / 1024 / 1024} MB, #{item.hits} hits"
          end
        end
      end
    end

    class Response

      attr_reader :items

      def initialize response
        @items = []
        response.split(/^\|$/).each do |raw_items| 
          keys_and_values = {}
          raw_items.strip.split(/\n/).collect do |value|
            next if value.empty?
            k, v = value.split(/:/)
            keys_and_values[k.downcase] = v.gsub(/;$/, '')
          end
          @items << Item.new(keys_and_values)
        end
      end
    end

    class Item

      DOWNLOAD_URL = "http://api.nzbmatrix.com/v1.1/download.php?id=%s&username=%s&apikey=%s"

      def initialize detail
        detail.each do |k, v|
          instance_variable_set("@#{k}", v)
          self.class.__send__(:attr_accessor, k)
        end
      end

      def download file_name=nil
        credentials = Options.get('credentials')
        url = sprintf(DOWNLOAD_URL, nzbid, credentials['username'], credentials['api_key'])
        $logger.debug "url=[#{url}]"

        begin
          nzb_data = RestClient.get(url)
        rescue SocketError => e
        end

        file = File.join(Options.get('download_dir'), file_name ? file_name : suitable_file_name)

        $logger.info "Downloaded '#{nzbname}' as #{file}"

        f = File.new(file, 'w')
        f.write(nzb_data)
        f.close
      end

      def suitable_file_name
        name = nzbname.gsub(/\s+/, '.') + ".nzb"
        $logger.debug name
        name
      end

    end

  end
end