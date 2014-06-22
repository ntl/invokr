class InvokrTest < Minitest::Test
  def test_incorrectly_invoking
    error = assert_raises Invokr::InputError do
      Invokr.invoke
    end

    assert_equal(
      "cannot invoke; missing required arguments: `method', `on' and `with'",
      error.message,
    )
  end
end
