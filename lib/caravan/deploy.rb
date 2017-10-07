require "colorize"

module Caravan
  module Deploy
    class << self
      def create_deployer(method = "shell")
        case method
        when "shell"
          return Caravan::DeployMethods::Shell.new
        when "scp"
          return Caravan::DeployMethods::Scp.new
        when "rsync"
          return Caravan::DeployMethods::Rsync.new
        when "rsync_local"
          return Caravan::DeployMethods::RsyncLocal.new
        else
          Message.error("Unknown deploy method \"#{method}\"")
          return nil
        end
      end
    end

    class Base
      attr_accessor :debug

      def initialize
        Message.info("Creating #{self.class.name}...")
        @debug = false
      end

      def run(src, dst)
        time_str = Time.now.strftime("%H:%M:%S").green
        Message.info("#{time_str} Deploying #{src} to #{dst}...")

        status = 0
        if block_given?
          status, output = yield src, dst
        end

        Message.error("deploying block returned false") unless status == 0
        return status
      end
    end
  end
end
