require "colorize"

module Caravan
  module Message
    class << self
      def info(msg)
        puts "[INFO] #{msg}"
      end

      def error(msg)
        puts "[ERROR] #{msg}".red
      end

      def warning(msg)
        puts "[WARN] #{msg}".yellow
      end

      def success(msg)
        puts "#{msg}".green
      end
    end
  end
end
