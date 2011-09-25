require 'jetty.jar'
require 'jetty-plus.jar'
require 'jetty-util.jar'
require 'servlet-api.jar'
require 'rack'
require 'jruby-rack'
require 'rack/handler/servlet'

class Rack::Handler::Jetty < Rack::Handler::Servlet

  def self.run(app, options)
    jetty = org.mortbay.jetty.Server.new options[:Port]
    context_path = options[:context_path] || "/"
    context = org.mortbay.jetty.servlet.Context.new(nil, context_path,
      org.mortbay.jetty.servlet.Context::NO_SESSIONS)

    servlet_pattern = options[:servlet_pattern] || "/*"
    
    # The filter acts as the entry point in to the application
    context.add_filter(
      filter_holder(app),
      servlet_pattern,
      org.mortbay.jetty.Handler::ALL)

    # FIXME Umm, this might be wrong
    context.set_resource_base(File.dirname(__FILE__))

    # if we don't have at least one servlet, the filter gets nothing
    context.add_servlet(org.mortbay.jetty.servlet.ServletHolder.new(
      org.mortbay.jetty.servlet.DefaultServlet.new), servlet_pattern)

    jetty.set_handler(context)
    jetty.start
    jetty.join
  end

  def self.filter_holder(app)
    context = org.jruby.rack.embed.Context.new("Jetty")
    dispatcher = 
      org.jruby.rack.embed.Dispatcher.new(context, self.new(app))

    filter = org.jruby.rack.embed.Filter.new(dispatcher, context)

    org.mortbay.jetty.servlet.FilterHolder.new(filter)
  end

end

Rack::Handler.register('jetty', 'Rack::Handler::Jetty')
