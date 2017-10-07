require "test_helper"

class DeployTest < CaravanTest
  context "test deploy" do
    should "create shell deployer" do
      shell_1 = Caravan::Deploy.create_deployer()
      shell_2 = Caravan::Deploy.create_deployer("shell")
      assert_equal(true, shell_1.is_a?(Caravan::DeployMethods::Shell))
      assert_equal(true, shell_2.is_a?(Caravan::DeployMethods::Shell))
    end

    should "create scp deployer" do
      scp = Caravan::Deploy.create_deployer("scp")
      assert_true(scp.is_a?(Caravan::DeployMethods::Scp))
    end

    should "create rsync deployer" do
      rsync = Caravan::Deploy.create_deployer("rsync")
      assert_true(rsync.is_a?(Caravan::DeployMethods::Rsync))
    end

    should "create rsync local deployer" do
      rsync_local = Caravan::Deploy.create_deployer("rsync_local")
      assert_true(rsync_local.is_a?(Caravan::DeployMethods::RsyncLocal))
    end

    should "error if deployer not exists" do
      assert_output("[ERROR] Unknown deploy method \"not_a_deployer\"".red << "\n") do
        output = Caravan::Deploy.create_deployer("not_a_deployer")
        assert_nil(output)
      end
    end
  end
end
