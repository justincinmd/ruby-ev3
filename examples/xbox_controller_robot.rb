require 'rubygems'
require 'ev3'
require 'ev3/connections/bluetooth'
require 'artoo'

INTERVAL = 0.1

connection :joystick, :adaptor => :joystick
device :controller, :driver => :xbox360, :connection => :joystick, :interval => INTERVAL

# Joystick and trigger values are 16-bit signed two's complement
# with a converted range of -32768..32767

# On the Joysticks, Joystick 0 is left, Joystick 1 is right
# Left and up are negative, right and down are positive

class Robot
  RIGHT_MOTOR = 'b'
  LEFT_MOTOR = 'a'
  CLAW_MOTOR = 'c'

  MAX_TURN = 40

  def initialize
    @brick = EV3::Brick.new(EV3::Connections::Bluetooth.new)
    @brick.connect
    # @brick.beep

    motors.each do |motor|
      motor.stop
      motor.speed = 0
      motor.start
    end
  end

  def claw_speed
    claw_motor.speed
  end

  def claw_speed=(speed)
    claw_motor.speed = speed
  end

  def move(speed, turn)
    turn_size = (MAX_TURN * turn).round
    drive_speed = (speed >= 0 ? [speed, 100 - turn_size.abs].min : [speed, -100 + turn_size.abs].max).round
    left_motor_speed = drive_speed + turn_size
    right_motor_speed = drive_speed - turn_size
    puts [left_motor_speed, right_motor_speed].inspect
    left_motor.speed = left_motor_speed
    right_motor.speed = right_motor_speed
  end

  def reverse
    left_motor.reverse
    right_motor.reverse
  end

  def stop
    motors.each do |motor|
      motor.speed = 0
      motor.stop
    end
  end

  def disconnect
    brick.disconnect
  end

  private

  attr_reader :brick

  def motors
    [left_motor, right_motor, claw_motor]
  end

  def left_motor
    brick.motor(LEFT_MOTOR)
  end

  def right_motor
    brick.motor(RIGHT_MOTOR)
  end

  def claw_motor
    brick.motor(CLAW_MOTOR)
  end
end

class ControllerHandler
  attr_reader :robot

  def initialize
    @robot = Robot.new
    @lt_value = 0
    @rt_value = 0
    @turn = 0
  end

  def rb_down
    @rb_down_time = Time.now
    @rb_down = true
  end

  def rb_up
    @lb_down_time = Time.now
    @rb_down = false
  end

  def lb_down
    @lb_down_time = Time.now
    @lb_down = true
  end

  def lb_up
    @rb_down_time = Time.now
    @lb_down = false
  end

  def dpad_right
    robot.reverse
  end

  def trigger_rt(value)
    @rt_value = signed_to_percentage(value)
  end

  def trigger_lt(value)
    @lt_value = signed_to_percentage(value)
  end

  def joystick(x)
    @turn = x.abs < 7500 ? 0 : x/32768.0
    puts @turn
  end

  def update_robot
    update_claw_speed
    robot.move(drive_speed, turn)
  end

  def update_claw_speed
    robot.claw_speed = claw_speed
    puts "Drive Speed: #{drive_speed}"
  end

  def quit
    puts 'Bye!'
    robot.stop
    robot.disconnect
    sleep 5
    exit
  end

  private

  attr_reader :turn

  def drive_speed
    @rt_value - @lt_value
  end

  def claw_speed
    if @lb_down == @rb_down
      0
    elsif @lb_down
      easing(100, 3, @lb_down_time)
    elsif @rb_down
      easing(-100, 3, @rb_down_time)
    end
  end

  def easing(target, interval, start_time)
    return target
    # Skipping easing for now
    passed = [Time.now - start_time, interval].min
    (target * (passed / interval.to_f)).to_i
  end

  def signed_to_percentage(number)
    ((number + 32768).to_f / (32768.0 + 32767.0) * 100.0).to_i
  end
end

handler = ControllerHandler.new

work do
  every (INTERVAL) {
    handler.update_robot
  }

  on controller, :joystick => proc { |*value|
    # Example value: ["robot_klulugtm_controller_joystick", {:x=>4011, :y=>55, :s=>0}]
    puts "joystick #{value[1][:s]} x:#{value[1][:x]} y:#{value[1][:y]}"
  }
  on controller, :joystick_0 => proc { |*value|
    # Example value: ["robot_klulugtm_controller_joystick", {:x=>4011, :y=>55, :s=>0}]
    x = value[1][:x]
    handler.joystick(x)
  }
  on controller, :button_dpad_right => proc { |*value|
    puts "Right dpad pressed"
    handler.dpad_right
  }
  on controller, :button_rb => proc { |*value|
    puts "Right bumper pressed"
    handler.rb_down
  }
  on controller, :button_up_rb => proc { |*value|
    puts "Right bumper released"
    handler.rb_up
  }
  on controller, :button_lb => proc { |*value|
    puts "Left bumper pressed"
    handler.lb_down
  }
  on controller, :button_up_lb => proc { |*value|
    puts "Left bumper released"
    handler.lb_up
  }
  on controller, :button_start => proc { |*value|
    puts "Start buttom pressed"
    handler.quit
  }
  on controller, :trigger_rt => proc { |*value|
    puts "trigger rt: #{value[1]}"
    handler.trigger_rt(value[1])
  }
  on controller, :trigger_lt => proc { |*value|
    puts "trigger lt: #{value[1]}"
    handler.trigger_lt(value[1])
  }
end
