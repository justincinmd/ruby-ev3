module EV3
  module Commands
    class Base
      attr_accessor :sequence_number

      def initialize(local_variables = 0, global_variables = 0)
        @local_variables = local_variables
        @global_variables = global_variables

        # Sequence number is currently unused, so I am setting it to zero
        self.sequence_number = 0
        @bytes = []
      end

      # Converts the command to an array of bytes to send to the EV3
      def to_bytes
        message = self.sequence_number.to_little_endian_byte_array(2) + variable_size_bytes + @bytes.clone

        # The message is proceeded by the message length
        message.size.to_little_endian_byte_array(2) + message
      end

      # Append a byte or multiple bytes to the command
      #
      # @param [Integer, Array<Integer>] byte_or_bytes to append to the command
      def <<(byte_or_bytes)
        bytes = byte_or_bytes.arrayify
        bytes.each { |byte| @bytes << byte }
      end

      # String representation of the command
      def to_s
        "#{self.class.name}: #{self.to_bytes.map{|byte| byte.to_s(16)}.join(', ')}"
      end

      # Raises an exception if the value isn't found in the range
      #
      # @param [Integer] value to check against the range
      # @param [String] variable_name for the exception message
      # @param [Range<Integer>] range the value should be in
      def validate_range!(value, variable_name, range)
        raise(ArgumentError, "#{variable_name} should be between #{range.min} and #{range.max}") unless range.include?(value)
      end

      # Raises an exception if the value isn't one of the constant values from the constant module or class
      #
      # @param [Integer] value to check against the constant
      # @param [String] variable_name for the exception message
      # @param [Class, Module] constant_container which contains constant values
      def validate_constant!(value, variable_name, constant_container)
        values = constant_container.constants.map{|c| constant_container.const_get(c) }
        raise(ArgumentError, "#{variable_name} should be of type #{constant_container.name}") unless values.include?(value)
      end

      # Raises an exception if the value isn't one of the type type_or_types
      #
      # @param [Integer] value to check against the constant
      # @param [String] variable_name for the exception message
      # @param [Class, Array<Class>] type_or_types type(s) to check the value against
      #
      # @example Validate if value is the specified type
      #   validate_type!(layer, 'layer', Integer)
      #
      # @example Validate if value is any of the specified types
      #    validate_type!(layer, 'layer', [Integer, Float])
      def validate_type!(value, variable_name, type_or_types)
        types = type_or_types.arrayify
        raise(ArgumentError, "#{variable_name} should be of type #{type.name}") unless types.any?{ |type| value.is_a?(type) }
      end

      private

      def variable_size_bytes
        #   Byte 6    Byte 5
        #  76543210  76543210
        #  --------  --------
        #  llllllgg  gggggggg
        #
        #        gg  gggggggg  Global variables [0..MAX_COMMAND_GLOBALS]
        #  llllll              Local variables  [0..MAX_COMMAND_LOCALS]
        [
          (@global_variables & 0xFF),
          (((@local_variables << 2) & 0b1111_1100) | (((@global_variables >> 8) & 0b0000_0011)))
        ]
      end
    end
  end
end