require "logger"

require "ev3/core_extensions"
require "ev3/validations"

require "ev3/brick"
require "ev3/commands"
require "ev3/constants"
require "ev3/version"


module EV3
  # A logger or nil if logging is disabled, defaults to a logger pointing at STDOUT
  #
  # @return [Logger, nil] logger
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  # Replace the default logger.
  # @note If this is set to nil, logging will be disabled.
  def self.logger=(new_logger)
    @logger = new_logger
  end

   # Helper to reload the gem in dev.
  def self.reload!
    $".grep(/lib\/ev3/).each{ |f| load(f) if File.exists?(f) }
  end
end