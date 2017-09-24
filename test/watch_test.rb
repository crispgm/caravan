require "test_helper"

class WatchTest < Minitest::Test
  def setup
    `mkdir -p test/output`
  end

  def teardown
    `rm -rf test/output`
  end

  def test_that_it_has_a_version_number
    refute_nil Caravan::VERSION
  end

  def test_it_works
    `exe/caravan test/fixtures test/output`
    Dir.chdir("test/output") do
      Dir.exist?("testfile")
    end
  end
end
