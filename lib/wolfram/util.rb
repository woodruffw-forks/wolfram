require 'cgi'

module Wolfram
  module Util

    def self.to_query(obj, key)
      "#{CGI.escape(key.to_s).gsub(/%(5B|5D)/n) { [$1].pack('H*') }}=#{CGI.escape(obj.to_s)}"
    end

    def self.to_param(obj)
      obj.map {|key, value| to_query(value, key) }.sort * '&'
    end

    def delegate(*meths)
      raise ArgumentError unless meths[-1].is_a?(Hash) && meths[-1].key?(:to)
      to_meth = meths.pop[:to]
      meths.each do |meth|
        define_method(meth) do |*args, &block|
          self.send(to_meth).send(meth, *args, &block)
        end
      end
    end
  end
end
