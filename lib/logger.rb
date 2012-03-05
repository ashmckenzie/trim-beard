class Logger

  def initialize level=:info
    unless @logger
      @logger = Logging.logger(STDOUT)
      @logger.level = level
    end
    @logger
  end

  def level
    @logger.level
  end

  def level= level
    @logger.level = level
  end

  def info msg
    message(:info, msg)
  end

  def warn msg
    message(:warn, msg)
  end

  def debug msg
    message(:debug, msg)
  end

  def error msg
    message(:error, msg)
  end

  def message level, msg
    m = caller[1].match(/(.+):(\d+):in `(.+)'/)
    file = m[1].sub("#{$APP_ROOT}/", '')
    line_number = m[2]
    method = m[3]
    @logger.send(level, "[#{file}:#{method}:#{line_number}] #{msg}")
  end

end