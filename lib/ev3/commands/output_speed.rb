module EV3
  module Commands
    class OutputSpeed < Output

      # Creates a new output speed
      #
      # @param (see EV3::Commands::Output#initialize)
      # @param [Integer] speed for the motor(s), as a percentage [-100..100]
      # @param (see #EV3::Commands::Output#initialize)
      def initialize(nos, speed, layer = DaisyChainLayer::EV3)
        super(nos, layer)

        validate_range!(speed, 'speed', -100..100)

        self << speed.to_ev3_data
      end

      # Output speed command
      # @return [ByteCodes]
      def command
        ByteCodes::OUTPUT_SPEED
      end
    end
  end
end