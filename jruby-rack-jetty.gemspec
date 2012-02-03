# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

spec = Gem::Specification.new do |s|
  s.name   = "jruby-rack-jetty"
  s.version = '0.1.1'
  s.platform = Gem::Platform::RUBY
  s.summary = "Jetty support for jruby-rack"
  s.description = 'A basic adapter that lets you run rack applications with jetty under JRuby'

  s.authors = ["Nick Griffiths", "Playlouder development team"]
  s.email   = ["nicobrevin@gmail.com", "devs@playlouder.com"]
  s.homepage = "https://github.com/nicobrevin/jruby-rack-jetty"

  s.add_dependency('jruby-rack', '~> 1.1.0')
  s.files = Dir["lib/**/*.rb", "java/**.jar"]
  s.require_paths = %w(lib java)
end
