require "simplecov"
SimpleCov.start

require "caravan"
require "minitest/autorun"
require "shoulda-context"

class CaravanTest < Minitest::Test
  def capture_stdout
    begin
      # The output stream must be an IO-like object. In this case we capture it in
      # an in-memory IO object so we can return the string value. You can assign any
      # IO object here.
      previous_stdout, $stdout = $stdout, StringIO.new
      yield
      $stdout.string
    ensure
      # Restore the previous value of stdout (typically equal to STDOUT).
      $stdout = previous_stdout
    end
  end

  def assert_true(condition)
    assert_equal(true, condition)
  end
end
