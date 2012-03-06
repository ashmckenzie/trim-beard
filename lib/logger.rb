class Logger

  attr_reader :level_label

  def initialize level=:info
    unless @logger
      @logger = Logging.logger(STDOUT)
      @logger.level = @level_label = level
    end
    @logger
  end

  def level= level
    @logger.level = @level_label = level
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
    if level_label == :debug
      m = caller[1].match(/(.+):(\d+):in `(.+)'/)
      file = m[1].sub("#{$APP_ROOT}/", '')
      line_number = m[2]
      method = m[3]
      msg = "[#{file}:#{method}:#{line_number}] #{msg}"
    end
    @logger.send(level, msg)
  end

end