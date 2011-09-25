require 'jetty.jar'
require 'jetty-plus.jar'
require 'jetty-util.jar'
require 'servlet-api.jar'
require 'rack'
require 'jruby-rack'
require 'rack/handler/servlet'
require 'rack/handler/jetty/log_adapter'

class Rack::Handler::Jetty < Rack::Handler::Servlet

  DEFAULT_MAX_THREADS = 1000

  def self.run(app, options)

    if options.fetch(:replace_jetty_logger, true)
      # We want to set the logger ASAP to get rid of stderr logging that comes out
      @logger = Rack::Handler::JettyLogAdapter.new(options[:logger], options[:log_prefix] ||
                               'JETTY: ')
      org.mortbay.log.Log.setLog(@logger)
    end

    jetty = org.mortbay.jetty.Server.new options[:Port]

    max_threads = options[:max_threads] || DEFAULT_MAX_THREADS
    thread_pool = org.mortbay.thread.QueuedThreadPool.new(max_threads)
    thread_pool.setName("http")
    log("created thread pool #{thread_pool} with #{max_threads} max threads")
    jetty.setThreadPool(thread_pool)


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

  def self.log(msg)
    @logger && @logger.info(msg)
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
