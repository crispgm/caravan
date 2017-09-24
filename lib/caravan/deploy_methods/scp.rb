require "caravan/deploy"

module Caravan
  module DeployMethods
    class Scp < Deploy::Base
      def run(src, dst, host)
        super(src, dst) do |s, d|
          `scp -r #{s} #{host}:#{d}`
        end
      end
    end
  end
end
