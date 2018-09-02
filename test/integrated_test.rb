require "test_helper"

class IntegratedTest < CaravanTest
  context "smoke tests" do
    setup do
      `mkdir -p test/output`
    end

    teardown do
      `rm -rf test/output`
      `rm caravan.yml`
    end

    should "has a version number" do
      refute_nil Caravan::VERSION
    end

    should "dump default conf" do
      Caravan.dump_default_conf
      assert_true(File.exist?("caravan.yml"))
    end

    should "load nil if no config file in source path" do
      conf = Caravan.process_conf(".")
      assert_equal(conf, nil)
    end

    should "load user specific config file" do
      conf = Caravan.process_conf("./test/fixtures/", "caravan-test.yml")
      assert_equal("specific_file_name", conf["master"]["dst"])
    end

    should "load user conf if config file in source path" do
      user_conf_path = File.expand_path("./test/output/caravan.user.yml")
      user_conf = Caravan::Config.default_conf.dup
      user_conf["master"]["deploy_mode"] = "rsync"
      Caravan::Config.dump(user_conf_path, user_conf)
      user_conf_loaded = Caravan::Config.from("./test/output/caravan.user.yml")
      assert_equal(user_conf, user_conf_loaded)
    end
  end
end
