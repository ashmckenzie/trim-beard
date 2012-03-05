module Providers
  module NZBMatrix
    class Base

      def username
        config['credentials']['username'] or raise Exceptions::CredentialsMissing.new('Username not set')
      end

      def api_key
        config['credentials']['api_key'] or raise Exceptions::CredentialsMissing.new('API key not set')
      end 

      def watch_directory
        config['directories']['watch'] or raise Exceptions::Missing.new('Watch directory not set')
      end

      private

      def config
        @config ||= Configuration.providers['nzbmatrix']
      end
    end

    class Request < Base

      SEARCH_URL = "http://api.nzbmatrix.com/v1.1/search.php?search=%s&catid=%s&username=%s&apikey=%s"

      def self.search query
        new.search(query)
      end

      def search query
        #url = URI.escape(sprintf(SEARCH_URL, query, 'tv-all', username, api_key))
        #url = URI.escape(sprintf(SEARCH_URL, query, 'movies-all', username, api_key))
        #response = NZBMatrix::Response.new RestClient.get(url)
        response = NZBMatrix::Response.new File.new('./tmp/zoolander.data').readlines.join("\n")
        # response.items.select { |x| x.category =~ /Xvid/ }.sort { |x,y| y.hits.to_i <=> x.hits.to_i }
      end

    end

    class Response < Base

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

    class Item < Base

      DOWNLOAD_URL = "http://api.nzbmatrix.com/v1.1/download.php?id=%s&username=%s&apikey=%s"

      def initialize detail
        detail.each do |k, v|
          instance_variable_set("@#{k}", v)
          self.class.__send__(:attr_accessor, k)
        end
      end

      def download file_name=nil
        url = sprintf(DOWNLOAD_URL, nzbid, username, api_key)
        # nzb_data = RestClient.get(url)
        # f = File.new(File.join(watch_directory, file_name ? file_name : suitable_file_name), 'w')
        # f.write(nzb_data)
        # f.close
      end

      def suitable_file_name
        nzbname.gsub(/\s+/, '.') + ".nzb"
      end

    end

  end
end