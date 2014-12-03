class InvokrTest < Minitest::Test
  def test_supplying_proc
    my_proc = ->a,b{a+b}

    result = Invokr.invoke proc: my_proc, with: { a: 1, b: 4 }

    assert_equal 5, result
  end

  def test_using_keyword_overrides_extra_arguments_error
    my_proc = ->a,b{a**b}

    result = Invokr.invoke proc: my_proc, using: { a: 2, b: 3, c: nil }

    assert_equal 8, result
  end

  def test_incorrectly_invoking
    error = assert_raises Invokr::InputError do
      Invokr.invoke
    end

    assert_equal(
      "cannot invoke; missing required arguments: `method', `on' and either `with' or `using'",
      error.message,
    )
  end
end
