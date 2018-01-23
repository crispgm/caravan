require "yaml"

module Caravan
  class Config < Hash
    DEFAULT_CONFIG = {
      "debug" => false,
      "deploy_mode" => "rsync_local",
      "incremental" => true,
      "exclude" => %w(
        .git .svn
      ),
      "once" => false
    }.freeze

    DEFAULT_CONFIG_NAME = "caravan.yml".freeze

    class << self
      def default_conf
        DEFAULT_CONFIG
      end

      def default_conf_name
        DEFAULT_CONFIG_NAME
      end

      def from(user_config_path)
        if File.exist?(user_config_path)
          YAML.load_file(user_config_path)
        else
          Caravan::Message.warn("User configuration [caravan.yml] not found.")
          Caravan::Message.warn("Use `caravan init` to generate.")
          default_conf.dup
        end
      end

      def dump(user_config_path, user_config)
        File.open(user_config_path, "w") do |f|
          f.write(user_config.to_yaml)
        end
      end

      def merge(options, conf)
        merged_conf = conf
        merged_conf["src"] = options[:src] if options.key?(:src)
        merged_conf["dst"] = options[:dst] if options.key?(:dst)
        merged_conf["debug"] = options[:debug] if options.key?(:debug)
        merged_conf["deploy_mode"] = options[:mode] if options.key?(:mode)
        merged_conf["exclude"] = options[:ignore] if options.key?(:ignore)
        merged_conf["once"] = options[:once] if options.key?(:once)

        merged_conf
      end

      def pretty_puts(conf)
        conf.each do |k, v|
          Caravan::Message.info("=> #{k}: #{v}")
        end
      end
    end
  end
end
