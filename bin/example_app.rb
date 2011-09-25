['java', 'lib'].each {|path| $LOAD_PATH.unshift(path) }
require 'rubygems'
require 'rack/handler/jetty'

app = Proc.new do |env|
  [200, {'Content-Type' => 'text/html'}, ['hello, world']]
end

handler = Rack::Handler.get('jetty')
handler.run app, {
  :Port        => 3000,

  :max_threads => 500,     # Max number of threads to allow in the http thread pool

  :logging     => true,    # If true, replaces the default jetty logger with a ruby
                           # logger and turns on other logging.  If false, it won't
                           # even try and require logger

  :logger      => nil,     # A logger, with standard ruby logger interface, to log to

  :context_path => '/',    # A context path for the app - all URIs will be underneath
                           # this path.

  :servlet_pattern => '/*',   # SCRIPT_NAME Pattern to match for requests.  Matching requests
                              # will be forward to your rack application

}

