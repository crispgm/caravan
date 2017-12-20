require "test_helper"

class MessageTest < CaravanTest
  context "test message" do
    should "print debug" do
      assert_output("[DEBUG] debug message".light_black << "\n") do
        Caravan::Message.debug("debug message")
      end

      assert_output("[INFO] info message\n") do
        Caravan::Message.info("info message")
      end

      assert_output("[ERROR] error message".red << "\n") do
        Caravan::Message.error("error message")
      end

      assert_output("[WARN] warn message".yellow << "\n") do
        Caravan::Message.warn("warn message")
      end

      assert_output("succ message".green << "\n") do
        Caravan::Message.success("succ message")
      end
    end
  end
end
