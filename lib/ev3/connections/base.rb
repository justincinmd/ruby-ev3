module EV3
  module Connections
    class Base

      def connect
        raise NotImplementedError
      end

      def write(command)
        raise NotImplementedError
      end
    end
  end
end