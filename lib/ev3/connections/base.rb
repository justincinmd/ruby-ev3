module EV3
  module Connections
    class Base

      def initialize
        @commands_sent = 0
      end

      def connect
        raise NotImplementedError
      end

      def write(command)
        command.sequence_number = @commands_sent
        perform_write(command)
        @commands_sent += 1
      end

      def perform_write(command)
        raise NotImplementedError
      end
    end

    # Base class for devices not found
    class DeviceNotFound < StandardError; end

    # Base class for rejected connections
    class ConnectionRejected < StandardError; end
  end
end