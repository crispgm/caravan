require "colorize"

module Caravan
  module Message
    class << self
      def debug(msg)
        puts "[DEBUG] #{msg}".light_black
      end

      def info(msg)
        puts "[INFO] #{msg}"
      end

      def error(msg)
        puts "[ERROR] #{msg}".red
      end

      def warn(msg)
        puts "[WARN] #{msg}".yellow
      end

      def success(msg)
        puts msg.green
      end
    end
  end
end
