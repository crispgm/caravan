require "caravan/deploy"

module Caravan
  module DeployMethods
    class Rsync < Deploy::Base
      def run(src, dst, host)
        super(src, dst) do |s, d|
          `rsync -avl #{s} #{host}:#{d}`
        end
      end
    end
  end
end
