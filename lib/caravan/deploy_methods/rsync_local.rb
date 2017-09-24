require "caravan/deploy"

module Caravan
  module DeployMethods
    class RsyncLocal < Deploy::Base
      def run(src, dst)
        super(src, dst) do |s, d|
          `rsync -rv #{s} #{d}`
        end
      end
    end
  end
end
