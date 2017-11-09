require "colorize"

module Caravan
  module Deploy
    class << self
      def create_deployer(src, dst, method = "shell")
        case method
        when "shell"
          return Caravan::DeployMethods::Shell.new(src, dst)
        when "scp"
          return Caravan::DeployMethods::Scp.new(src, dst)
        when "rsync"
          return Caravan::DeployMethods::Rsync.new(src, dst)
        when "rsync_local"
          return Caravan::DeployMethods::RsyncLocal.new(src, dst)
        else
          Message.error("Unknown deploy method \"#{method}\"")
          return nil
        end
      end
    end

    class Base
      attr_accessor :debug
      attr_reader :src, :dst

      def initialize(src, dst)
        Message.info("Creating #{self.class.name}...")
        @src = src
        @dst = dst
        @debug = false
      end

      def after_create
        Message.info("#{self.class.name} is created.")

        if block_given?
          yield
        end
      end

      def after_change(changes)
        changes.each do |change|
          Caravan::Message.info("#{change} was changed.")
        end

        true
      end

      def before_deploy
        true
      end

      def run
        time_str = Time.now.strftime("%H:%M:%S").green
        Message.info("#{time_str} Deploying #{src} to #{dst}...")

        status = 0
        if block_given?
          status, output = yield src, dst
        end

        Message.error("deploying block returned false") unless status == 0
        return status
      end
      
      def after_deploy
      end
    end
  end
end
