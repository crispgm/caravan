require "caravan/deploy"

module Caravan
  module DeployMethods
    class RsyncLocal < Deploy::Base
      def run(src, dst)
        super(src, dst) do |s, d|
          Caravan::Command.run("rsync -rv #{s} #{d}", @debug)
        end
      end
    end
  end
end
