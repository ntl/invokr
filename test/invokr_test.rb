class InvokrTest < Minitest::Test
  def test_supplying_proc
    my_proc = ->a,b{a+b}

    result = Invokr.invoke proc: my_proc, with: { a: 1, b: 4 }

    assert_equal 5, result
  end

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
