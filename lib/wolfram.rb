require 'nokogiri'
require 'wolfram/xml_container'
require 'wolfram/util'
require 'wolfram/query'
require 'wolfram/result'
require 'wolfram/pod'
require 'wolfram/assumption'

module Wolfram
  extend self
  
  DefaultQueryURI = "http://api.wolframalpha.com/v2/query"
  
  attr_accessor :appid, :query_uri
  
  def query_uri
    @query_uri ||= DefaultQueryURI
  end
  
  def query(input, options = {})
    Query.new(input, options)
  end
  
  def fetch(input, options = {})
    query(input, options).fetch
  end
  
  # return a module named <type> in <namespace> (create if necessary)
  def mixin(namespace, type)
    Object.const_get "#{namespace.name}::#{type}"
  rescue NameError
    namespace.module_eval "module #{type}; end"
    namespace.const_get type
  end
  
  class MissingNodeError < RuntimeError
  end
end

Wolfram.appid = ENV['WOLFRAM_API_KEY']
