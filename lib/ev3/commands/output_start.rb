module EV3
  module Commands
    class OutputStart < Output
      # Output start byte code
      # @return [ByteCodes]
      def command
        ByteCodes::OUTPUT_START
      end
    end
  end
end