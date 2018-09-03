require "colorize"

module Caravan
  module Deploy
    class << self
      def create_deployer(src, dst, method = "shell")
        case method
        when "shell"
          Caravan::DeployMethods::Shell.new(src, dst)
        when "scp"
          Caravan::DeployMethods::Scp.new(src, dst)
        when "rsync"
          Caravan::DeployMethods::Rsync.new(src, dst)
        when "rsync_local"
          Caravan::DeployMethods::RsyncLocal.new(src, dst)
        else
          Message.error("Unknown deploy method \"#{method}\"")
          nil
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

      def handle_change(modified, added, removed)
        @modified = modified
        @added = added
        @removed = removed

        after_change
      end

      def after_create
        Message.info("#{self.class.name} is created.")

        if block_given?
          ret_val = yield
          debug_msg("Block `after_create` returned #{ret_val}")
          false if ret_val == false
        end

        true
      end

      def after_change
        @modified.each do |change|
          Caravan::Message.info("#{change} was changed.")
        end

        @added.each do |change|
          Caravan::Message.info("#{change} was created.")
        end

        @removed.each do |change|
          Caravan::Message.info("#{change} was removed.")
        end

        if block_given?
          ret_val = yield @modified, @added, @removed
          debug_msg("Block `after_change` returned #{ret_val}")
          false if ret_val == false
        end

        true
      end

      def before_deploy
        if block_given?
          ret_val = yield
          debug_msg("Block `before_deploy` returned #{ret_val}")
          false if ret_val == false
        end

        true
      end

      def run
        time_str = Time.now.strftime("%H:%M:%S").green
        Message.info("#{time_str} Deploying #{src} to #{dst}...")

        status = 0
        if block_given?
          status, _output = yield src, dst
          debug_msg("Block `run` returned #{status}")
        end

        Message.error("Deploying block returned false") unless status.zero?
        status
      end

      def after_deploy
        if block_given?
          ret_val = yield
          debug_msg("Block `after_deploy` returned #{ret_val}")
          false if ret_val == false
        end

        true
      end

      def before_destroy
        if block_given?
          ret_val = yield
          debug_msg("Block `before_destroy` returned #{ret_val}")
          false if ret_val == false
        end

        true
      end

      def relative_path(path)
        working_dir = Dir.pwd
        path_routes = path.split(working_dir)
        return nil if path_routes.nil? ||
                      path_routes.empty? ||
                      path_routes.size < 2

        path_routes[-1]
      end

      private

      def debug_msg(msg)
        Caravan::Message.debug(msg) if @debug
      end
    end
  end
end
