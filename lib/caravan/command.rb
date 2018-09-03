module Caravan
  class Command
    class << self
      def run(cmd, debug = false)
        output = `#{cmd}`
        Caravan::Message.debug(cmd) if debug
        return $CHILD_STATUS.exitstatus, output
      end
    end
  end
end
