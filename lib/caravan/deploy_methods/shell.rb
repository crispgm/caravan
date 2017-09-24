module Caravan
  module DeployMethods
    class Shell < Caravan::Deploy::Base
      def run(src, dst)
        super(src, dst) do |s, d|
          `cp -r #{s} #{d}`
        end
      end
    end
  end
end
