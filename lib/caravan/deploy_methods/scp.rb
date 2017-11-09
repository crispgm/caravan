require "caravan/deploy"

module Caravan
  module DeployMethods
    class Scp < Deploy::Base
      def run
        super do |s, d|
          Caravan::Command.run("scp -r #{s} #{d}", @debug)
        end
      end
    end
  end
end
