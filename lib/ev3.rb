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


# TODO: Consider moving these monkey patches into a refinement

class Integer
  BYTE_CONVERSION = {1 => 'c', 2 => 'v', 4 => 'V'}

  # Convert to EV3 variable data
  # see http://python-ev3.org/parameterencoding.html#subpar
  def to_ev3_data
    [0b1000_0011] + self.to_little_endian_byte_array(4)
  end

  # Convert the number to an array of little endian bytes
  #
  # @param [Integer] number_of_bytes that should represent the integer
  def to_little_endian_byte_array(number_of_bytes = 4)
    raise ArgumentError unless BYTE_CONVERSION.has_key?(number_of_bytes)
    [self].pack(BYTE_CONVERSION[number_of_bytes]).bytes
  end
end

class Object
  # Converts object to an array if it's not one
  def arrayify
    if self.is_a?(Array)
      self
    else
      [self]
    end
  end
end

class TrueClass
  # Converts to EV3 byte
  def to_ev3_data
    1
  end
end

class FalseClass
  # Converts to EV3 byte
  def to_ev3_data
    0
  end
end