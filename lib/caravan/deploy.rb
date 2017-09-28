module Caravan
  module Deploy
    class << self
      def create_deployer(method = 'shell')
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
        Message.info("Deploying #{src} to #{dst}...")

        ret_val = true
        if block_given?
          ret_val = yield src, dst
        end

        Message.error("deploying block returned false") if ret_val == false
        return ret_val
      end
    end
  end
end
