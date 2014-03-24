module EV3
  class Brick
    attr_reader :connection

    # Create a new brick connection
    #
    # @param [instance subclassing Connections::Base] connection to the brick
    def initialize(connection)
      @connection = connection
    end

    # Connect to the EV3
    def connect
      self.connection.connect
    end

    # Play a short beep on the EV3
    def beep
      self.execute(Commands::SoundTone.new)
    end

    # Play a tone on the EV3 using the specified options
    def play_tone(volume, frequency, duration)
      command = Commands::SoundTone.new(volume, frequency, duration)
      self.execute(command)
    end

    # Execute the command
    #
    # @param [instance subclassing Commands::Base] command to execute
    def execute(command)
      self.connection.write(command)
    end
  end
end