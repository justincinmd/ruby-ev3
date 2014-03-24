require 'ev3/connections/base'
require 'serialport'

module EV3
  module Connections

    class Bluetooth < Base
      attr_reader :device

      # Create a new bluetooth device
      #
      # @param [String] device on the Mac, a dev device, and on windows a com port
      def initialize(device = '/dev/tty.EV3-SerialPort')
        @device = device
        @commands_sent = 0
      end

      def connect
        @serial_port = ::SerialPort.new(@device, 57600, 8, 1, SerialPort::NONE)
        @serial_port.flow_control = ::SerialPort::HARD
        @serial_port.read_timeout = 5000
      end

      # Set the sequence number on the command and write it to the bluetooth connection
      #
      # @param [instance subclassing Commands::Base] command to execute
      def write(command)
        command.sequence_number = @commands_sent
        command.to_bytes.each do |b|
          @serial_port.putc b
        end
        @commands_sent += 1
      end
    end

  end
end