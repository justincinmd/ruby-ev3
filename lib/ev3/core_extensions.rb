module EV3
  module CoreExtensions
    refine Integer do
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