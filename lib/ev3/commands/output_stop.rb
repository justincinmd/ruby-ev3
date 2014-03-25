module EV3
  module Commands
    class OutputStop < Output
      using EV3::CoreExtensions

      # Creates a new output stop command
      #
      # @param (see EV3::Commands::Output#initialize)
      # @param [TrueClass, FalseClass] brake stop the motor or let it glide to rest
      # @param (see #EV3::Commands::Output#initialize)
      def initialize(nos, brake = false, layer = DaisyChainLayer::EV3)
        super(nos, layer)

        validate_type!(brake, 'brake', [TrueClass, FalseClass])

        self << brake.to_ev3_data
      end

      # Output stop command
      # @return [ByteCodes]
      def command
        ByteCodes::OUTPUT_STOP
      end
    end
  end
end