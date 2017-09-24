require "yaml"

module Caravan
  class Config < Hash
    DEFAULT_CONFIG = {
      "deploy_mode" => "rsync_local",
      "incremental" => true,
      "exclude" => %w(
        .git .svn
      )
    }.freeze

    class << self
      def default_conf
        DEFAULT_CONFIG
      end

      def from(user_config_path)
        if File.exist?(user_config_path)
          YAML.load_file(user_config_path)
        else
          dump_conf(user_config_path, default_conf)
          default_conf
        end
      end

      def dump_conf(user_config_path, user_config)
        File.open(user_config_path, "w") do |f|
          f.write(user_config.to_yaml)
        end
      end

      def pretty_puts(conf)
        conf.each do |k, v|
          Message.info("    => #{k}: #{v}")
        end
      end
    end
  end
end
