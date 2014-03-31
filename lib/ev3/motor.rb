module EV3
  class Motor
    include EV3::Validations::Constant
    include EV3::Validations::Type

    A = 1
    B = 2
    C = 4
    D = 8

    def initialize(motor, brick)
      validate_constant!(motor, 'motor', self.class)
      validate_type!(brick, 'brick', EV3::Brick)

      @motor = motor
      @brick = brick
      self.speed = 0
      stop
    end

    def start
      @on = true
      brick.execute(Commands::OutputStart.new(motor, layer))
    end

    def stop(brake = false)
      @on = false
      brick.execute(Commands::OutputStop.new(motor, brake, layer))
    end

    def on?
      @on
    end

    def speed
      on? ? @speed : 0
    end

    def speed=(new_speed)
      if @speed.nil? || new_speed != @speed
        @speed = new_speed
        brick.execute(Commands::OutputSpeed.new(motor, new_speed, layer))
      end
    end

    def reverse
      brick.execute(Commands::OutputPolarity.new(motor, Commands::OutputPolarity::OPPOSITE, layer))
    end

    private

    attr_reader :brick, :motor

    def layer
      brick.layer
    end
  end
end