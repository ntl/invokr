class RestArgsTest < Minitest::Test
  def test_passing_in_splat
    error = assert_raises Invokr::UnsupportedArgumentsError do
      Invokr.invoke(
        method: :splat_argument,
        on:     TestMethodBank,
        with:   { guitarist: 'trey' },
      )
    end

    assert_equal(
      "unsupported splat argument(s) `rest' when invoking method `splat_argument' on #<TestMethodBank:0xdeadbeef>",
      error.message,
    )
  end
end
