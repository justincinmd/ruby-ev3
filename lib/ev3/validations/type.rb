module EV3
  module Validations
    module Type
      using EV3::CoreExtensions

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
    end
  end
end