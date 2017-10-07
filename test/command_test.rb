require "test_helper"

class CommandTest < CaravanTest
  context "run command" do
    should "succeed and return 0" do
      status, output = Caravan::Command.run("echo test-command")
      assert_equal(0, status)
      assert_equal("test-command\n", output)
    end

    should "not run inexisted command and return 127" do
      status, output = Caravan::Command.run("sh ./scripts/inexisted.sh")
      assert_equal(127, status)
      assert_equal("", output)
    end

    should "run but fail and return 255" do
      status, output = Caravan::Command.run("sh ./test/scripts/error_command.sh")
      assert_equal(255, status)
      assert_equal("there is an error\n", output)
    end
  end
end
