require 'rubygems'
require 'artoo'

connection :joystick, :adaptor => :joystick
device :controller, :driver => :xbox360, :connection => :joystick, :interval => 0.1

# Joystick and trigger values are 16-bit signed two's complement
# with a converted range of -32768..32767

# On the Joysticks, Joystick 0 is left, Joystick 1 is right
# Left and up are negative, right and down are positive

work do
  on controller, :joystick => proc { |*value|
    # Example value: ["robot_klulugtm_controller_joystick", {:x=>4011, :y=>55, :s=>0}]
    puts "joystick #{value[1][:s]} x:#{value[1][:x]} y:#{value[1][:y]}"
  }
  on controller, :button_a => proc { |*value|
    puts "ayyyy!"
  }
  on controller, :button_b => proc { |*value|
    puts "bee!"
  }
  on controller, :button_x => proc { |*value|
    puts "exxx!"
  }
  on controller, :button_y => proc { |*value|
    puts "why!"
  }

  on controller, :trigger_rt => proc { |*value|
    puts "trigger rt: #{value[1]}"
  }
end