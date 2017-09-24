module Caravan
  class Config < Hash
    DEFAULT_CONFIG = {
      # shell, scp, rsync
      "deploy_mode" => "shell",
      "incremental" => true,
      "exclude" => %w(
        .git .svn
      )
    }.map { |k, v| [k, v.freeze] }].freeze
  end

  class << self
    def from(user_config_path)
    end

    def dump_default_conf(user_config_path)
    end
  end
end
