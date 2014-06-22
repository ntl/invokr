class QueryTest < Minitest::Test
  def setup
    method = TestMethodBank.method :one_required_one_optional_argument
    @method = Invokr.query_method method
  end

  def test_dependencies
    assert_equal [:album, :guitarist], @method.dependencies
  end

  def test_optional_dependencies
    assert_equal [:guitarist], @method.optional_dependencies
  end

  def test_required_dependencies
    assert_equal [:album], @method.required_dependencies
  end
end
