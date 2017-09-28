module Caravan
  module DeployMethods
    class Shell < Caravan::Deploy::Base
      def run(src, dst)
        super(src, dst) do |s, d|
          Caravan::Command.run("cp -r #{s} #{d}", @debug)
        end
      end
    end
  end
end
