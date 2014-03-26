module EV3
  module CoreExtensions
    BYTE_CONVERSION = {1 => 'c', 2 => 'v', 4 => 'V'}
    BYTES_FOLLOWING_ENCODING = {1 => 0b01, 2 => 0b10, 4 => 0b11}

    refine Integer do
      # Convert to EV3 variable data
      # see http://python-ev3.org/parameterencoding.html#subpar
      # TODO: Add 1 and 2 byte encoding (http://python-ev3.org/parameterencoding.html)
      def to_ev3_data
        case self
        when 0..31
          self
        when -32..-1
          # Short negative constant
          0b0011_1111 & self.to_little_endian_byte_array(1).first
        else
          # 4-byte variable
          [0b1000_0000 | BYTES_FOLLOWING_ENCODING[4]] + self.to_little_endian_byte_array(4)
        end
      end

      # Convert the number to an array of little endian bytes
      #
      # @param [Integer] number_of_bytes that should represent the integer
      def to_little_endian_byte_array(number_of_bytes = 4)
        raise ArgumentError unless BYTE_CONVERSION.has_key?(number_of_bytes)
        [self].pack(BYTE_CONVERSION[number_of_bytes]).bytes
      end
    end

    refine Object do
      # Converts object to an array if it's not one
      def arrayify
        if self.is_a?(Array)
          self
        else
          [self]
        end
      end
    end

    refine TrueClass do
      # Converts to EV3 byte
      def to_ev3_data
        1
      end
    end

    refine FalseClass do
      # Converts to EV3 byte
      def to_ev3_data
        0
      end
    end
  end
end