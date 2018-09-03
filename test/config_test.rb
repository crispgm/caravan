require "test_helper"

class ConfigTest < CaravanTest
  context "test config generation" do
    setup do
      @output_path = File.expand_path("./test/caravan.test.yml")
      @user_conf_path = File.expand_path("./test/caravan.user.yml")
      @default_conf = Caravan::Config.default_conf
      Caravan::Config.dump(@output_path, @default_conf)
    end

    teardown do
      `rm #{@output_path}`
      `rm #{@user_conf_path}`
    end

    should "file dumped to yaml" do
      assert_true(File.exist?(@output_path))
    end

    should "get default configuration" do
      assert_true(@default_conf.is_a?(Hash))
    end

    should "load user configuration" do
      user_conf = @default_conf.dup
      user_conf["deploy_mode"] = "rsync"
      Caravan::Config.dump(@user_conf_path, user_conf)
      user_conf_loaded = Caravan::Config.from("./test/caravan.user.yml")
      assert_equal(user_conf, user_conf_loaded)
    end

    should "get default if user configuration is not found" do
      std_output = capture_stdout do
        output = Caravan::Config.from("caravan.inexisted.yml")
        assert_equal(output, nil)
      end

      assert_true(std_output.include?("[caravan.yml] not found"))
    end

    should "pretty print" do
      std_output = capture_stdout do
        Caravan::Config.pretty_puts(@default_conf)
      end

      assert_true(std_output.include?("[INFO] => master:"))
    end
  end

  context "merge options with conf" do
    should "assign conf if no options" do
      conf = {
        "master": {
          "c": 1
        }
      }
      merged = Caravan::Config.merge({}, conf)
      assert_equal({"c": 1}, merged)
    end

    should "merge if options exist" do
      conf = {
        "master": {
          "c": 1
        }
      }
      merged = Caravan::Config.merge({:debug => true}, conf)
      assert_true(merged["debug"])
    end

    should "override src" do
      conf = {
        "master": {
          "src": 1
        }
      }
      merged = Caravan::Config.merge({:src => 2}, conf)
      assert_equal(2, merged["src"])
    end
  end
end
