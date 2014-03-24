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

class Integer
  # Convert to EV3 variable data
  def to_ev3_data
    [0b1000_0011] + self.to_little_endian_byte_array(4)
  end

  # Convert the number to an array of little endian bytes
  #
  # @param [Integer] number_of_bytes that should represent the integer
  def to_little_endian_byte_array(number_of_bytes = 4)
    raise NotImplementedError if self < 0
    bytes = []
    tmp_number = self
    while tmp_number.abs > 0
      bytes << (tmp_number & 0xFF)
      tmp_number = tmp_number >> 8
    end
    bytes = bytes[0..(number_of_bytes - 1)]
    until bytes.size == number_of_bytes
      bytes << 0
    end
    bytes
  end
end