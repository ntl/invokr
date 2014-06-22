class BlockArgsTest < Minitest::Test
  def test_supplying_block_argument_explicitly
    actual = Invokr.invoke(
      method: :block_argument,
      on:     TestMethodBank,
      with:   { album_block: -> { 'farmhouse' } },
    )

    assert_equal 'farmhouse', actual
  end

  def test_supplying_block_argument_implicitly
    actual = Invokr.invoke(
      method: :block_argument,
      on:     TestMethodBank,
      with:   {},
      block:  -> { 'farmhouse' },
    )

    assert_equal 'farmhouse', actual
  end

  def test_failing_to_supply_block_argument
    error = assert_raises Invokr::MissingArgumentsError do
      Invokr.invoke(
        method: :block_argument,
        on:     TestMethodBank,
        with:   {},
      )
    end

    assert_equal(
      "missing required argument(s) `album_block' when invoking method `block_argument' on #<TestMethodBank:0xdeadbeef>",
      error.message,
    )
  end

  def test_supplying_block_argument_implicitly_and_explicitly
    error = assert_raises Invokr::ExtraArgumentsError do
      Invokr.invoke(
        method: :block_argument,
        on:     TestMethodBank,
        with:   { album_block: -> { 'farmhouse' } },
        block:  -> { 'farmhouse' },
      )
    end

    assert_equal(
      "unused argument(s) `album_block' when invoking method `block_argument' on #<TestMethodBank:0xdeadbeef>",
      error.message,
    )
  end

  def test_implicit_block
    actual = Invokr.invoke(
      method: :just_yields,
      on:     TestMethodBank,
      with:   {},
      block:  -> { 'farmhouse' },
    )

    assert_equal 'farmhouse', actual
  end
end
