require "test_helper"

class DeployTest < CaravanTest

  SOURCE_FOLDER = "test/fixtures/".freeze
  TARGET_FOLDER = "test/target_folder".freeze

  context "test deploy" do
    should "create shell deployer by default" do
      deployer = Caravan::Deploy.create_deployer("#{SOURCE_FOLDER}/*", TARGET_FOLDER)
      assert_equal(true, deployer.is_a?(Caravan::DeployMethods::Shell))
    end

    context "test relative path" do
      setup do
        @deployer = Caravan::Deploy.create_deployer("#{SOURCE_FOLDER}/*", TARGET_FOLDER)
      end

      should "extract relative path from full path" do
        assert_equal("/test/fixtures/testfile", @deployer.relative_path("#{Dir.pwd}/test/fixtures/testfile"))
      end

      should "return nil if path is nil" do
        assert_nil(@deployer.relative_path("/test/fixtures/testfile"))
      end

      should "return nil if path the same" do
        assert_nil(@deployer.relative_path(Dir.pwd))
      end
    end

    context "test shell deployer" do
      setup do
        Caravan::Command.run("mkdir -p #{TARGET_FOLDER}")
      end

      teardown do
        Caravan::Command.run("rm -rf #{TARGET_FOLDER}")
      end

      should "create and deploy" do
        deployer = Caravan::Deploy.create_deployer("#{SOURCE_FOLDER}/*", TARGET_FOLDER, "shell")
        deployer.debug = true
        assert_true(deployer.is_a?(Caravan::DeployMethods::Shell))
        deployer.after_create()
        deployer.before_deploy()
        status = deployer.run()
        deployer.after_deploy()
        deployer.before_destroy()
        assert_equal(0, status)
        assert_true(File.exist?("#{TARGET_FOLDER}/testfile"))
      end
    end

    context "test scp deployer" do
      setup do
        Caravan::Command.run("mkdir -p #{TARGET_FOLDER}")
      end

      teardown do
        Caravan::Command.run("rm -rf #{TARGET_FOLDER}")
      end

      should "create and deploy" do
        deployer = Caravan::Deploy.create_deployer("#{SOURCE_FOLDER}/*", TARGET_FOLDER, "scp")
        deployer.debug = true
        assert_true(deployer.is_a?(Caravan::DeployMethods::Scp))
        status = deployer.run()
        assert_equal(0, status)
        assert_true(File.exist?("#{TARGET_FOLDER}/testfile"))
      end
    end

    context "test rsync deployer" do
      setup do
        Caravan::Command.run("mkdir -p #{TARGET_FOLDER}")
      end

      teardown do
        Caravan::Command.run("rm -rf #{TARGET_FOLDER}")
      end

      should "create and deploy" do
        deployer = Caravan::Deploy.create_deployer("#{SOURCE_FOLDER}/*", TARGET_FOLDER, "rsync")
        deployer.debug = true
        assert_true(deployer.is_a?(Caravan::DeployMethods::Rsync))
        status = deployer.run()
        assert_equal(0, status)
        assert_true(File.exist?("#{TARGET_FOLDER}/testfile"))
        puts `ls #{TARGET_FOLDER}`
      end
    end

    context "test rsync_local deployer" do
      setup do
        Caravan::Command.run("mkdir -p #{TARGET_FOLDER}")
      end

      teardown do
        Caravan::Command.run("rm -rf #{TARGET_FOLDER}")
      end

      should "create and deploy" do
        deployer = Caravan::Deploy.create_deployer(SOURCE_FOLDER, TARGET_FOLDER, "rsync_local")
        deployer.debug = true
        assert_true(deployer.is_a?(Caravan::DeployMethods::RsyncLocal))
        status = deployer.run()
        assert_equal(0, status)
        assert_true(File.exist?("#{TARGET_FOLDER}/testfile"))
      end
    end

    should "error if deployer not exists" do
      assert_output("[ERROR] Unknown deploy method \"not_a_deployer\"".red << "\n") do
        output = Caravan::Deploy.create_deployer("#{SOURCE_FOLDER}/*", TARGET_FOLDER, "not_a_deployer")
        assert_nil(output)
      end
    end
  end
end
