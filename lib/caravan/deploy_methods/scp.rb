require "caravan/deploy"

module Caravan
  module DeployMethods
    class Scp < Deploy::Base
      def run(src, dst)
        super(src, dst) do |s, d|
          `scp -r #{s} #{d}`
        end
      end
    end
  end
end
