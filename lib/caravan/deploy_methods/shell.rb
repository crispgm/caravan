module Caravan
  module DeployMethods
    class Shell < Caravan::Deploy::Base
      def after_create
        super do
          Caravan::Message.info("Notice: Shell Deployer is like copy, mainly designed for test.")
        end
      end

      def before_deploy
        super do
          Caravan::Message.info("Hook: before_deploy")
        end
      end

      def run
        super do |s, d|
          Caravan::Command.run("cp -r #{s} #{d}", @debug)
        end
      end

      def after_deploy
        super do
          Caravan::Message.info("Hook: after_deploy")
        end
      end

      def before_destroy
        super do
          Caravan::Message.info("Deployer destroyed")
        end
      end
    end
  end
end
