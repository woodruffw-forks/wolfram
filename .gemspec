# -*- encoding: utf-8 -*-
require 'rubygems' unless Object.const_defined?(:Gem)
require File.dirname(__FILE__) + "/lib/wolfram/version"

Gem::Specification.new do |s|
  s.name        = "wolfram"
  s.version     = Wolfram::VERSION
  s.authors     = ["Gabriel Horner", "Ian White"]
  s.email       = "gabriel.horner@gmail.com"
  s.homepage    = "http://github.com/cldwalker/wolfram"
  s.summary = "Wolfram V2 API client"
  s.description =  "Explore the vast world of computational knowledge available for free via Wolfram's v2 API."
  s.required_rubygems_version = ">= 1.3.6"
  s.executables = ['wolfram']
  s.add_dependency 'nokogiri', '>= 1.4.3'
  s.add_development_dependency 'rr'
  s.add_development_dependency 'bacon', '>= 1.1.0'
  s.add_development_dependency 'bacon-rr'
  s.add_development_dependency 'bacon-bits'
  s.files = Dir.glob(%w[{lib,test}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c} **/deps.rip]) + %w{Rakefile .gemspec}
  s.files += Dir.glob(['test/fixtures/*.xml']) + %w{.travis.yml CONTRIBUTING.md}
  s.extra_rdoc_files = ["README.md", "LICENSE.txt"]
  s.license = 'MIT'
end
