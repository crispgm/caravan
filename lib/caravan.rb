require "caravan/command"
require "caravan/config"
require "caravan/config_migration"
require "caravan/deploy"
require "caravan/deploy_methods/shell"
require "caravan/deploy_methods/scp"
require "caravan/deploy_methods/rsync"
require "caravan/deploy_methods/rsync_local"
require "caravan/message"
require "caravan/version"

require "listen"

module Caravan
  class << self
    def start(merged_conf)
      src_path = merged_conf["src"]
      target_path = merged_conf["dst"]
      deploy_mode = merged_conf["deploy_mode"]
      ignores = merged_conf["exclude"]
      debug = merged_conf["debug"]

      Caravan::Config.pretty_puts(merged_conf)

      deployer = Caravan::Deploy.create_deployer(
        src_path,
        target_path,
        deploy_mode
      )
      deployer.debug = true if debug
      exit(-1) if deployer.nil?

      listener = create_listener(deployer, src_path)
      ignores.each do |item|
        listener.ignore(Regexp.compile(item))
      end

      Caravan::Message.success("Starting to watch #{src_path}...")
      deployer.after_create
      if merged_conf["once"]
        deploy_once(deployer)
        exit(0)
      end
      listener.start

      trap("INT") do
        listener.stop
        deployer.before_destroy
        Caravan::Message.success("\tHalting watching.")
        exit(0)
      end

      sleep_forever
    end

    def deploy_once(deployer)
      deployer.before_deploy
      deployer.run
      deployer.after_deploy
      Caravan::Message.success("Deployed once.")
    end

    def create_listener(deployer, src_path)
      Listen.to(src_path) do |modified, added, removed|
        # rubocop:disable Lint/NonLocalExitFromIterator
        return unless deployer.handle_change(modified, added, removed)
        return unless deployer.before_deploy
        deployer.run
        deployer.after_deploy
        # rubocop:enable Lint/NonLocalExitFromIterator
      end
    end

    def process_conf(src_path, yaml_name = Caravan::Config.default_conf_name)
      Caravan::Message.success("Reading configuration...")
      src_path = '.' if src_path.nil?
      user_config_path = File.join(File.expand_path(src_path), yaml_name)
      conf = Caravan::Config.from(user_config_path)
      Caravan::Message.warn(
        "Caravan now support multiple specs in `caravan.yml`. " \
        "The default spec is `master`. " \
        "And we detect that you may need to migrate."
      ) if Caravan::ConfigMigration.need_migrate?(conf)
      conf
    end

    def sleep_forever
      loop { sleep 1000 }
    end

    def dump_default_conf
      user_config_path = File.join(
        File.expand_path("."),
        Caravan::Config.default_conf_name
      )
      default_conf = Caravan::Config.default_conf

      Caravan::Config.dump(user_config_path, default_conf)
    end
  end
end
