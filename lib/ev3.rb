require "ev3/core_extensions"
require "ev3/brick"
require "ev3/commands"
require "ev3/constants"
require "ev3/version"

module EV3
   # Helper to reload the gem in dev.
  def self.reload!
    $".grep(/lib\/ev3/).each{ |f| load(f) if File.exists?(f) }
  end
end