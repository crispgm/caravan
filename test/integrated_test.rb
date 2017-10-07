require "test_helper"

class IntegratedTest < CaravanTest
  context "smoke tests" do
    setup do
      `mkdir -p test/output`
    end

    teardown do
      `rm -rf test/output`
    end

    should "has a version number" do
      refute_nil Caravan::VERSION
    end
  end
end
