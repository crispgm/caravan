require "test_helper"

class ConfigTest < CaravanTest
  context "test config generation" do
    setup do
      @output_path = File.expand_path("./test/caravan.test.yml")
      @default_conf = Caravan::Config.default_conf
      Caravan::Config.dump(@output_path, @default_conf)
    end

    teardown do
      `rm #{@output_path}`
    end

    should "file dumped to yaml" do
      assert_true(File.exist?(@output_path))
    end

    should "get default configuration" do
      assert_true(@default_conf.is_a?(Hash))
    end

    should "load user configuration" do
    end

    should "get default if user configuration is not found" do
      std_output = capture_stdout do
        output = Caravan::Config.from("caravan.inexisted.yml")
        assert_equal(output, @default_conf)
      end

      assert_true(std_output.include?("[caravan.yml] not found"))
    end

    should "pretty print" do
      std_output = capture_stdout do
        Caravan::Config.pretty_puts(@default_conf)
      end

      assert_true(std_output.include?("=> exclude:"))
    end
  end
end
