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
        super()
        @device = device
      end

      def connect
        @serial_port = ::SerialPort.new(@device, 57600, 8, 1, SerialPort::NONE)
        @serial_port.flow_control = ::SerialPort::HARD
        @serial_port.read_timeout = 5000
      end

      def disconnect
        @serial_port.close
      end

      # Write the command to the bluetooth connection
      #
      # @param [instance subclassing Commands::Base] command to execute
      def perform_write(command)
        command.to_bytes.each do |b|
          @serial_port.putc b
        end
      end
    end

  end
end