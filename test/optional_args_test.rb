class OptionalArgsTest < Minitest::Test
  def test_overriding_optional_argument
    actual = Invokr.invoke(
      method: :optional_argument,
      on:     TestMethodBank,
      with:   { album: 'rift' },
    )

    assert_equal 'rift', actual
  end

  def test_default_optional_argument
    actual = Invokr.invoke(
      method: :optional_argument,
      on:     TestMethodBank,
      with:   {},
    )

    assert_equal 'junta', actual
  end

  def test_use_extra_args_as_hash_for_optional_argument
    hsh = { guitarist: 'trey' }

    actual = Invokr.invoke(
      method: :optional_argument,
      on:     TestMethodBank,
      with:   hsh,
    )

    assert_equal hsh, actual
  end

  def test_cant_use_extra_args_as_hash_to_override_optional_argument
    error = assert_raises Invokr::ExtraArgumentsError do
      Invokr.invoke(
        method: :optional_argument,
        on:     TestMethodBank,
        with:   { album: 'junta', guitarist: 'trey' },
      )
    end

    assert_equal(
      "unused argument(s) `guitarist' when invoking method `optional_argument' on #<TestMethodBank:0xdeadbeef>",
      error.message,
    )
  end

  def test_argument_after_optional_argument_raises_error
    error = assert_raises Invokr::OptionalPositionalArgumentError do
      Invokr.invoke(
        method: :double_optional_argument,
        on:     TestMethodBank,
        with:   {},
      )
    end

    expected_error_message = <<-MESSAGE
method `double_optional_argument' has optional positional argument `album2', after optional argument `album1'.

We cannot use this method because there's no way to supply an explicit value for `album2' without knowing the default value for `album1'. It's technically possible to overcome this with S-expression analysis, but a much simpler solution would be to use keyword arguments.
    MESSAGE

    assert_equal expected_error_message, error.message
  end
end
