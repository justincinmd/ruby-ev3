module EV3
  module Commands
    class SoundTone < Base
      # Creates a new sound tone command
      #
      # @param [Integer] Volume of the sound [0..100]
      # @param [Integer] Frequency in Hertz [0..50,000]
      # @param [Integer] Duration in miliseconds [0..1 Year]
      def initialize(volume = 50, frequency = 1000, duration = 500)
        super()

        validate_range!(volume, 'volume', 0..100)
        validate_range!(frequency, 'frequency', 0..50_000) # 0 - 50,000 Hz
        validate_range!(duration, 'duration', 0..(1000 * 60 * 60 * 24 * 365)) # Up to a year

        self << CommandType::DIRECT_COMMAND_NO_REPLY
        self << ByteCodes::SOUND
        self << SoundSubCodes::TONE
        self << volume.to_ev3_data
        self << frequency.to_ev3_data
        self << duration.to_ev3_data
      end
    end
  end
end