module EV3
  # High-level interface for interacting with Motors.
  # @todo Implement methods to read motor speed and tacho information.
  class Motor
    include EV3::Validations::Constant
    include EV3::Validations::Type

    A = 1
    B = 2
    C = 4
    D = 8

    # Create a new motor and perform some initial setup, stopping the motor and zeroing the speed.
    # @param [Motor] motor A, B, C or D constant, corresponding to the EV3 motor ports.
    # @param [EV3::Brick] brick the brick the motor is connected to.
    #
    # @example Motor attached to port A of brick
    #   EV3::Motor.new(EV3::Motor::A, brick)
    def initialize(motor, brick)
      validate_constant!(motor, 'motor', self.class)
      validate_type!(brick, 'brick', EV3::Brick)

      @motor = motor
      @brick = brick
      # Setting the motor speed before calling start appears to be necessary
      self.speed = 0
      stop
    end

    # Starts the motor.  Default speed is zero, and should be controlled with {#speed}.
    def start
      @on = true
      brick.execute(Commands::OutputStart.new(motor, layer))
    end

    # Stop the motor
    # @param [true, false] brake stops the motor faster and holds it in position if true.
    def stop(brake = false)
      @on = false
      brick.execute(Commands::OutputStop.new(motor, brake, layer))
    end

    # @return [Boolean] true if the motor has started, false otherwise.
    def on?
      @on
    end

    # @return [int] the speed the motor is set to run at.
    # @note This is not necessarily the speed the motor is actually running at.
    # @note This is zero when the motor is stopped.
    def speed
      on? ? @speed : 0
    end

    # Sets the speed of the motor.
    # @param [int] new_speed from -100..100.
    #
    # @note The brick is only updated if the speed is changing.
    def speed=(new_speed)
      if @speed.nil? || new_speed != @speed
        @speed = new_speed
        brick.execute(Commands::OutputSpeed.new(motor, new_speed, layer))
      end
    end

    # Causes the motor to run in the reverse direction.
    # @note This doesn't change the speed reading, just the direction the motor spins.  In other words, positive
    #   speeds result in the motor spinning in the opposite direction.
    def reverse
      brick.execute(Commands::OutputPolarity.new(motor, Commands::OutputPolarity::OPPOSITE, layer))
    end

    private

    attr_reader :brick, :motor

    # Helper for accessing the brick's layer (for daisy chaining)
    def layer
      brick.layer
    end
  end
end