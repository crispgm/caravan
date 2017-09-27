require "caravan/deploy"

module Caravan
  module DeployMethods
    class Rsync < Deploy::Base
      def run(src, dst)
        super(src, dst) do |s, d|
           puts "rsync -avl #{s} #{d}"
          `rsync -avl #{s} #{d}`
        end
      end
    end
  end
end
