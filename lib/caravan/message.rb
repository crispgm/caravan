require "colorize"

module Caravan
  module Message
    class << self
      def info(msg)
        puts msg
      end

      def error(msg)
        puts msg.red
      end

      def warning(msg)
        puts msg.yellow
      end

      def success(msg)
        puts msg.green
      end
    end
  end
end
