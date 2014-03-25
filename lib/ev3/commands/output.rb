module EV3
  module Commands
    class Output < Base
      # Creates a new output
      #
      # @param [Integer] nos output bit field [0x00..0x0F]
      # @param [DaisyChainLayer] layer chain layer number [0..3]
      def initialize(nos, layer = DaisyChainLayer::EV3)
        super()

        validate_range!(nos, 'nos', 0x00..0x0F)
        validate_constant!(layer, 'layer', DaisyChainLayer)

        self << command_type
        self << command
        self << layer.to_ev3_data
        self << nos.to_ev3_data
      end

      # The command type.  Override if something other than CommandType::DIRECT_COMMAND_NO_REPLY
      # @return [CommandType]
      def command_type
        CommandType::DIRECT_COMMAND_NO_REPLY
      end

      # The output command to run
      # @abstract
      # @return [ByteCodes]
      def command
        raise NotImplementedError
      end
    end
  end
end