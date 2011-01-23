require 'nokogiri'
require 'wac/xml_container'
require 'wac/util'
require 'wac/query'
require 'wac/result'
require 'wac/pod'
require 'wac/assumption'

module Wac
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

Wac.appid = ENV['WOLFRAM_API_KEY']
