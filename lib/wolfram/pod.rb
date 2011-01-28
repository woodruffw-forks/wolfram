module Wolfram
  class Pod
    include XmlContainer
    include Enumerable
    extend Util

    delegate :[], :each, :to => :subpods

    def self.collection(xml, options = {})
      Nokogiri::XML(xml.to_s).search('pod').map {|p_xml| new(p_xml, options)}
    end

    attr_reader :subpods, :query, :states
    def initialize(xml, options = {})
      @query = options[:query]
      @xml = Nokogiri::XML(xml.to_s).search('pod').first
      @subpods = Subpod.collection(@xml.search('subpod'), options)
      @states = State.collection(@xml.search('states'), options)
      @xml or raise MissingNodeError, "<pod> node missing from xml: #{xml[0..20]}..."
      types.each {|type| extend type}
    end

    def to_s
      "#{title}: #{structured? ? plaintext : "'#{markup[0..20]}...'"} #{states.join(", ") if states.any?}"
    end

    def inspect
      "#<#{scanner}: #{to_s}>"
    end

    def types
      @types ||= scanner.split(',').map {|type| Util.module_get(Result, type)}
    end

    def plaintext
      (e = subpods.detect(&:plaintext)) && e.plaintext
    end

    def img
      (e = subpods.detect(&:plaintext)) && e.img
    end

    def markup
      @markup ||= (xml.search('markup').text || '')
    end

    def structured?
      subpods.any?
    end

    class Subpod
      include XmlContainer

      def self.collection(xml, options = {})
        Nokogiri::XML(xml.to_s).search('subpod').map {|s_xml| new(s_xml, options) }
      end

      def initialize(xml, options = {})
        @query = options[:query]
        @xml = Nokogiri::Slop(xml.to_s).search('subpod').first
        @xml or raise MissingNodeError, "<subpod> node missing from xml: #{xml[0..20]}..."
      end

      def plaintext
        (e = xml.plaintext) && e.text
      end

      def img
        xml.img
      end
    end

    class State
      attr_reader :name, :input

      def self.collection(xml, options = {})
        Nokogiri::XML(xml.to_s).search('state').map {|s_xml|
          new(s_xml['name'], options.merge(:input => s_xml['input']))
        }
      end

      def initialize(name, options = {})
        @query = options[:query]
        @input = options[:input]
        @name = name
      end

      def to_query(key)
        Util.to_query(name, key)
      end

      def to_s
        "[#{name}...]"
      end

      def inspect
        "#<State: #{to_s}>"
      end

      def requery
        podstate = @query.params[:podstate] ? [@query.params[:podstate], input] : input
        Query.new(@query.input, @query.options.merge(:podstate => podstate))
      end

      def refetch
        requery.fetch
      end
    end
  end
end
