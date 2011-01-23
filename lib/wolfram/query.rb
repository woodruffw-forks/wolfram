require 'open-uri'

module Wolfram
  # responsible for constructing a query, and returning the io stream for the query, and creating a Result
  # has an input, appid and options
  class Query
    include OpenURI

    attr_accessor :input, :options, :appid, :query_uri

    def initialize(input, options = {})
      @input = input
      @appid = options.delete(:appid) || Wolfram.appid || raise("No API key set")
      @query_uri = options.delete(:query_uri) || Wolfram.query_uri
      @options = options
    end

    # has the result been fetched?
    def fetched?
      @result ? true : false
    end

    # go and fetch the result, this is done automaticaly if you ask for the result
    def fetch
      @result = Result.new(data, :query => self)
    end

    # the query result
    def result
      fetch unless fetched?
      @result
    end

    # the uri that this query will issue a get request to
    def uri
      "#{query_uri}?#{Util.to_param(params)}"
    end

    def params
      options.merge(:input => input, :appid => appid)
    end

    def data
      open(uri).read
    end

    def inspect
      out = "q: \"#{input}\""
      out << " #{options[:podstate]}" if options[:podstate]
      out << " (assuming #{options[:assumption]})" if options[:assumption]
      out << ", a: #{result.datatypes}" if fetched?
      out
    end
  end
end
