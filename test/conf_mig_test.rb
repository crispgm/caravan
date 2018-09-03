require "test_helper"

class ConfMigTest < CaravanTest
  context "need migrate" do
    should "return true of nil or empty" do
      assert_equal(true, Caravan::ConfigMigration.need_migrate?(nil))
      assert_equal(true, Caravan::ConfigMigration.need_migrate?({}))
    end

    should "return true" do
      conf = {}
      conf["debug"]=  true,
      assert_equal(true, Caravan::ConfigMigration.need_migrate?(conf))
    end

    should "return false" do
      conf = {}
      conf["debug"]=  true,
      conf["src"] = "."
      conf["dst"] = "dummy"
      conf["deploy_mode"] = "rsync"
      assert_equal(false, Caravan::ConfigMigration.need_migrate?(conf))
    end
  end
end
