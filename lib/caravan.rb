require "listen"

require "caravan/deploy"
require "caravan/deploy_methods/shell"
require "caravan/deploy_methods/scp"
require "caravan/deploy_methods/rsync"
require "caravan/deploy_methods/rsync_local"
require "caravan/message"
require "caravan/version"

module Caravan
  class << self
    def start(src_path = ".", target_path)
      deployer = Deploy.create_deployer('rsync_local')

      listener = Listen.to(src_path) do |modified, added, removed|
        unless (modified.empty? && added.empty? && removed.empty?)
          deployer.run(src_path, target_path)

          (added + modified + removed).each do |change|
            Message.info("#{change} was changed.")
          end
        end
      end

      Message.success("Starting to watch #{src_path}...")
      deployer.run(src_path, target_path)
      listener.start
      
      trap("INT") do
        listener.stop
        Message.success("\tHalting watching.")
        exit 0
      end

      sleep_forever
    end

    def sleep_forever
      loop { sleep 1000 }
    end
  end
end
