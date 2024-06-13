# frozen_string_literal: true

require "test_helper"

class TestStreamforce < ActiveSupport::TestCase
  test "it has a version number" do
    assert_not_nil ::Streamforce::VERSION
  end
end
