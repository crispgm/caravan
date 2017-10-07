require "caravan/command"
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
      merged_conf = Caravan::Config.merge(options, process_conf(options[:src]))
      src_path = merged_conf["src"]
      target_path = merged_conf["dst"]
      deploy_mode = merged_conf["deploy_mode"]
      ignores = merged_conf["exclude"]
      debug = merged_conf["debug"]

      Caravan::Config.pretty_puts(merged_conf)

      deployer = Caravan::Deploy.create_deployer(deploy_mode)
      deployer.debug = true if debug
      if deployer.nil?
        exit -1
      end

      listener = create_listener(deployer, src_path, target_path)
      ignores.each do |item|
        listener.ignore(Regexp.compile(item))
      end

      Caravan::Message.success("Starting to watch #{src_path}...")
      deployer.run(src_path, target_path)
      listener.start
      
      trap("INT") do
        listener.stop
        Caravan::Message.success("\tHalting watching.")
        exit 0
      end

      sleep_forever
    end

    def create_listener(deployer, src_path, target_path)
      Listen.to(src_path) do |modified, added, removed|
        unless (modified.empty? && added.empty? && removed.empty?)
          (added + modified + removed).each do |change|
            Caravan::Message.info("#{change} was changed.")
          end

          deployer.run(src_path, target_path)
        end
      end
    end

    def process_conf(src_path)
      Caravan::Message.success("Reading configuration...")
      user_config_path = File.join(File.expand_path(src_path), DEFAULT_CONFIG_NAME)
      conf = Caravan::Config.from(user_config_path)
      conf
    end

    def sleep_forever
      loop { sleep 1000 }
    end
  end
end
