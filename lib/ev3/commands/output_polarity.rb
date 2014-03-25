module EV3
  module Commands
    class OutputPolarity < Output
      FORWARD = 1
      BACKWARD = -1
      OPPOSITE = 0

      # Creates a new output
      #
      # @param (see EV3::Commands::Output#initialize)
      # @param [Integer] polarity value from OutputPolarity constants
      # @param (see #EV3::Commands::Output#initialize)
      def initialize(nos, polarity = OPPOSITE, layer = DaisyChainLayer::EV3)
        super(nos, layer)

        validate_constant!(polarity, 'polarity', OutputPolarity)

        self << polarity.to_ev3_data
      end

      # Output polarity command
      # @return [ByteCodes]
      def command
        ByteCodes::OUTPUT_POLARITY
      end
    end
  end
end