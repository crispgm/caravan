require "caravan/config"
require "caravan/deploy"
require "caravan/deploy_methods/shell"
require "caravan/deploy_methods/scp"
require "caravan/deploy_methods/rsync"
require "caravan/deploy_methods/rsync_local"
require "caravan/message"
require "caravan/version"

require "listen"

DEFAULT_CONFIG_NAME = "caravan.yml".freeze

module Caravan
  class << self
    def start(options)
      src_path = options[:src]
      target_path = options[:dst]
      mode = options[:mode]
      ignores = options[:ignore]

      deployer = Deploy.create_deployer(mode)
      if deployer.nil?
        exit -1
      end

      process_conf

      listener = Listen.to(src_path) do |modified, added, removed|
        unless (modified.empty? && added.empty? && removed.empty?)
          (added + modified + removed).each do |change|
            Message.info("#{change} was changed.")
          end

          deployer.run(src_path, target_path)
        end
      end

      listener.ignore(ignores)

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

    def process_conf
      Message.success("Reading configuration...")
      conf = Caravan::Config.from(DEFAULT_CONFIG_NAME)
      Config.pretty_puts(conf)
    end

    def sleep_forever
      loop { sleep 1000 }
    end
  end
end
