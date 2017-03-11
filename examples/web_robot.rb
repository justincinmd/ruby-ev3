require 'rubygems'
require 'ev3'
require 'ev3/connections/bluetooth'
require 'webrick'
require 'json'


class Robot
  RIGHT_MOTOR = 'b'
  LEFT_MOTOR = 'a'
  CLAW_MOTOR = 'c'

  MAX_TURN = 40

  def initialize
    @brick = EV3::Brick.new(EV3::Connections::Bluetooth.new('/dev/rfcomm0'))
    @brick.connect
    @brick.beep

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

robot =  Robot.new()

server = WEBrick::HTTPServer.new(:Port=>2000)

server.mount_proc '/' do |req, res|
  puts "Received #{req.body}"
  parsed = JSON.parse(req.body)
  angle = parsed['angle']
  throttle = parsed['throttle']
  throttle = (throttle * 100).round
  angle = angle.abs < 0.25 ? 0 : angle
  puts "Setting Angle: #{angle}, Throttle: #{throttle}"
  robot.move(throttle, angle)
end

trap("INT") do
  robot.stop
  robot.disconnect
  server.shutdown
end
server.start
