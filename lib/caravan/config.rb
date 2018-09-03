require "yaml"

module Caravan
  class Config < Hash
    DEFAULT_CONFIG = {
      "master" => {
        "debug" => false,
        "deploy_mode" => "rsync",
        "incremental" => true,
        "exclude" => %w(
          .git .svn
        ),
        "once" => false
      }
    }.freeze

    DEFAULT_CONFIG_NAME = "caravan.yml".freeze
    DEFAULT_SPEC_NAME = "master".freeze

    class << self
      def default_conf
        DEFAULT_CONFIG.dup
      end

      def default_conf_name
        DEFAULT_CONFIG_NAME
      end

      def default_spec_name
        DEFAULT_SPEC_NAME
      end

      def from(user_config_path)
        if File.exist?(user_config_path)
          YAML.load_file(user_config_path)
        else
          Caravan::Message.warn("User configuration [caravan.yml] not found.")
          Caravan::Message.warn("Use `caravan --init` to generate.")
          nil
        end
      end

      def dump(user_config_path, user_config)
        # rubocop:disable Metrics/LineLength
        File.open(user_config_path, "w") do |f|
          f.write("# Generated Caravan's configuration file.\n")
          f.write("# Use `caravan --help` for instructions on all the configuration values.\n")
          f.write("# Add `src` and `dst` to specify the source and destination.\n")
          f.write(user_config.to_yaml)
        end
        # rubocop:enable Metrics/LineLength
      end

      def merge(options, conf, spec = Caravan::Config.default_spec_name)
        merged_conf = if conf.nil?
                        Caravan::Message.warn("Fail to load conf. Use default instead.")
                        default_spec_name = Caravan::Config.default_spec_name
                        Caravan::Config.default_conf[default_spec_name]
                      else
                        stringify_keys(conf)[spec]
                      end

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

      private

      def stringify_keys(conf)
        new_conf = {}
        conf.each do |sym, v|
          new_conf[sym.to_s] = v
        end
        new_conf
      end
    end
  end
end
