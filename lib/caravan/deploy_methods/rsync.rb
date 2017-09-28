require "caravan/deploy"

module Caravan
  module DeployMethods
    class Rsync < Deploy::Base
      def run(src, dst)
        super(src, dst) do |s, d|
          Caravan::Command.run("rsync -avl #{s} #{d}", @debug)
        end
      end
    end
  end
end
