require "test_helper"
require "listen"

class LibTest < CaravanTest
  context "caravan tests" do
    should "create a listen" do
      deployer = Caravan::Deploy.create_deployer(".", ".", "shell")
      listener = Caravan.create_listener(deployer, ".")
      assert_equal(true, listener.is_a?(Listen::Listener))
    end
  end
end
