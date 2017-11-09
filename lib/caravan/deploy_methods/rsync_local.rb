require "caravan/deploy"

module Caravan
  module DeployMethods
    class RsyncLocal < Deploy::Base
      def run
        super do |s, d|
          Caravan::Command.run("rsync -rv #{s} #{d}", @debug)
        end
      end
    end
  end
end
