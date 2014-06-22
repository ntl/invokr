class RequiredArgsTest < Minitest::Test
  def test_required_argument
    actual = Invokr.invoke(
      method: :required_argument,
      on:     TestMethodBank,
      with:   { album: 'junta' },
    )

    assert_equal 'junta', actual
  end

  def test_failing_to_supply_required_arguments
    error = assert_raises Invokr::MissingArgumentsError do
      Invokr.invoke(
        method: :multiple_required_arguments,
        on:     TestMethodBank,
        with:   {},
      )
    end

    assert_equal(
      "missing required argument(s) `album', `guitarist' when invoking method `multiple_required_arguments' on #<TestMethodBank:0xdeadbeef>",
      error.message,
    )
  end

  def test_refuses_to_invoke_if_unused_args_are_passed
    error = assert_raises Invokr::ExtraArgumentsError do
      Invokr.invoke(
        method: :required_argument,
        on:     TestMethodBank,
        with:   { album: 'junta', guitarist: 'trey' },
      )
    end

    assert_equal(
      "unused argument(s) `guitarist' when invoking method `required_argument' on #<TestMethodBank:0xdeadbeef>",
      error.message,
    )
  end
end
