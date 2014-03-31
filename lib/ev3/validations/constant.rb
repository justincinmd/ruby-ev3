module EV3
  module Validations
    module Constant
      # Raises an exception if the value isn't one of the constant values from the constant module or class
      #
      # @param [Integer] value to check against the constant
      # @param [String] variable_name for the exception message
      # @param [Class, Module] constant_container which contains constant values
      def validate_constant!(value, variable_name, constant_container)
        values = constant_container.constants.map{|c| constant_container.const_get(c) }
        raise(ArgumentError, "#{variable_name} should be of type #{constant_container.name}") unless values.include?(value)
      end
    end
  end
end