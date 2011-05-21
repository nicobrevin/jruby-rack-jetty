['java', 'lib'].each {|path| $LOAD_PATH.unshift(path) }
require 'rubygems'
require 'jetty.jar'
require 'jetty-plus.jar'
require 'jetty-util.jar'
require 'servlet-api.jar'
require 'rack'
require 'jruby-rack'
require 'rack/handler/jetty'

app = Proc.new do |env|
  [200, {'Content-Type' => 'text/html'}, ['hello, world']]
end

handler = Rack::Handler.get('jetty')
handler.run(app, :Port => 3000)
