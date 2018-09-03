module Caravan
  class ConfigMigration
    class << self
      def need_migrate?(conf)
        return true if conf.nil? || conf.empty?

        if !conf.key?("src") ||
           !conf.key?("dst") ||
           !conf.key?("deploy_mode")
          Caravan::Message.debug("Conf may need migrate.")
          return true
        end

        false
      end
    end
  end
end
