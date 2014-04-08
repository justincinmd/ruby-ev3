require 'ev3/connections/base'
require 'socket'

module EV3
  module Connections

    # Your EV3 should be connected to WIFI.
    #
    # This was tested with the recommended
    # {http://www.amazon.com/gp/product/B0036R9XRU/ref=as_li_ss_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B0036R9XRU&linkCode=as2&tag=litbitofcod-20 NETGEAR N150 Wi-Fi USB Adapter}.
    #
    # @example Connecting a brick to wifi and beeping:
    #  brick = EV3::Brick.new(EV3::Connections::Wifi.new)
    #  brick.connect
    #  brick.beep
    #  brick.disconnect
    class Wifi < Base
      # Create a new wifi device
      def initialize
        super()
        BasicSocket.do_not_reverse_lookup = true
      end

      # Connects to the EV3 over WIFI
      # @note The EV3 and the listener must be on the same network.
      # @note This can take up to 10 seconds.
      # @raise [WifiConnectionRejected] if the EV3 rejects the TCP connection
      def connect
        locate_ev3
        connect_to_ev3
      end

      # Close the connection to the EV3
      # @note If the EV3 isn't disconnected, it can refuse later connections.
      def disconnect
        @tcp_socket.close
      end

      # Send the command to the EV3
      #
      # @param [instance subclassing Commands::Base] command to execute
      def perform_write(command)
        @tcp_socket.send(command.to_bytes.pack('C*'), 0)
      end

      private

      # Listen for the EV3 and request it to open its TCP port.
      def locate_ev3
        # Listen for the EV3 UDP broadcasts.
        udp_socket = UDPSocket.new
        udp_socket.bind('0.0.0.0', 3015)
        data, addr = udp_socket.recvfrom(1024)

        @serial_number = data.lines[0].split[1]
        @port = data.lines[1].split[1].to_i
        @name = data.lines[2].split[1]
        @protocol = data.lines[3].split[1]
        @ev3_address = addr[2]

        EV3.logger.info("Located #{@name}\n" +
                        "Serial Number: #{@serial_number}\n" +
                        "Port: #{@port}\n" +
                        "Protocol: #{@protocol}\n" +
                        "Address: #{@ev3_address}") unless EV3.logger.nil?

        open_ev3_tcp_port(udp_socket)
      end

      # Contact the EV3.  This causes it to start listening on the TCP port it broadcast.
      def open_ev3_tcp_port(udp_socket)
        udp_socket.connect(@ev3_address, @port)
        udp_socket.send('c', 0)
        udp_socket.close
        EV3.logger.info("Requested EV3 to open TCP port #{@port}") unless EV3.logger.nil?
        sleep 1
      end

      # Connect to the EV3's TCP port
      def connect_to_ev3
        EV3.logger.info("Connecting to EV3 on TCP Port #{@port}") unless EV3.logger.nil?
        @tcp_socket = TCPSocket.new(@ev3_address, @port)
        @tcp_socket.send("GET /target?sn=#{@serial_number} VMTP1.0\nProtocol: #{@protocol}", 0)
        accept_msg = @tcp_socket.recv(1024)
        raise WifiConnectionRejected, "Connection Failed" if accept_msg.strip != 'Accept:EV340'
        EV3.logger.info("Connection Completed Successfully") unless EV3.logger.nil?
      end
    end

    # Thrown if the EV3 rejects the connection
    class WifiConnectionRejected < ConnectionRejected; end
  end
end