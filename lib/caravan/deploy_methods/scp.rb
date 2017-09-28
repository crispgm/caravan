require "caravan/deploy"

module Caravan
  module DeployMethods
    class Scp < Deploy::Base
      def run(src, dst)
        super(src, dst) do |s, d|
          Caravan::Command.run("scp -r #{s} #{d}", @debug)
        end
      end
    end
  end
end
