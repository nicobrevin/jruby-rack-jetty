require 'jetty'
require 'logger'

class Rack::Handler::JettyLogAdapter

  include_class 'org.mortbay.log.Logger'
  include org.mortbay.log.Logger

  attr_reader :logger

  def initialize(l=nil, prefix='')
    @logger = l || ::Logger.new(STDOUT)
    @prefix = prefix
  end

  def is_debug_enabled
    logger.debug?
  end

  def set_debug_enabled
    logger.warn("can't change logging status")
  end

  def warn(msg, *args)
    logger.warn(@prefix + sub(msg, args))
  end

  def info(msg, *args)
    logger.info(@prefix + sub(msg, args))
  end

  def debug(msg, *args)
    logger.debug(@prefix + sub(msg, args))
  end

  def error(msg, *args)
    logger.error(@prefix + sub(msg, args))
  end

  def fatal(msg, *args)
    logger.fatal(@prefix + sub(msg, args))
  end

  def get_logger(name)
    self
  end

  def sub(msg, *args); msg.gsub("{}") { args.shift }; end
end
