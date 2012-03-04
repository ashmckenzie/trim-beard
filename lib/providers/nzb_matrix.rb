module Providers
  module NZBMatrix

    class Base

      def username
        config['username'] or raise Exceptions::CredentialsMissing.new('Username not set')
      end

      def api_key
        config['api_key'] or raise Exceptions::CredentialsMissing.new('API key not set')
      end 

      private

      def config
        unless @config
          config = APP_CONFIG['credentials']['nzbmatrix']
        else
          @config
        end
      end
    end

    class Request < Base

      SEARCH_URL = "http://api.nzbmatrix.com/v1.1/search.php?search=%s&catid=%s&username=%s&apikey=%s"

      def self.search query
        new.search(query)
      end

      def search query
        #url = URI.escape(sprintf(SEARCH_URL, query, 'tv-all', username, api_key))
        url = URI.escape(sprintf(SEARCH_URL, query, 'movies-all', username, api_key))
        response = NZBMatrix::Response.new RestClient.get(url)
        binding.pry
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

      def download
        url = sprintf(DOWNLOAD_URL, nzbid, username, api_key)
      end

      def suitable_file_name
        nzbname.gsub(/\s+/, '.') + ".nzb"
      end

    end

  end
end