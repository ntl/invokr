module KeywordArgsTest
  class OptionalKeywordArgsTest < Minitest::Test
    def setup
      skip unless RUBY_VERSION >= '2.0' and RUBY_ENGINE == 'ruby'
    end

    def test_overriding_optional_keyword_argument
      actual = Invokr.invoke(
        method: :optional_keyword_argument,
        on:     TestMethodBank,
        with:   { album: 'billy_breathes' },
      )

      assert_equal 'billy_breathes', actual
    end

    def test_using_default_optional_keyword_argument
      actual = Invokr.invoke(
        method: :optional_keyword_argument,
        on:     TestMethodBank,
        with:   {},
      )

      assert_equal 'pitcher_of_nectar', actual
    end

    def test_querying_optional_keyword_argument
      method = Invokr.query_method TestMethodBank.method :optional_keyword_argument

      assert_equal [:album], method.optional_dependencies
    end

    def test_passing_in_splat_raises_error
      error = assert_raises Invokr::UnsupportedArgumentsError do
        Invokr.invoke(
          method: :keyword_splat_argument,
          on:     TestMethodBank,
          with:   { guitarist: 'trey' },
        )
      end

      assert_equal(
        "unsupported splat argument(s) `rest' when invoking method `keyword_splat_argument' on #<TestMethodBank:0xdeadbeef>",
        error.message,
      )
    end
  end

  class RequiredKeywordArgsTest < Minitest::Test
    def setup
      skip unless RUBY_VERSION >= '2.0' and RUBY_ENGINE == 'ruby'
    end

    def test_supplying_required_keyword_argument
      actual = Invokr.invoke(
        method: :required_keyword_argument,
        on:     TestMethodBank,
        with:   { album: 'pitcher_of_nectar' },
      )

      assert_equal 'pitcher_of_nectar', actual
    end

    def test_failing_to_supply_a_required_keyword_argument
      error = assert_raises Invokr::MissingArgumentsError do
        Invokr.invoke(
          method: :required_keyword_argument,
          on:     TestMethodBank,
          with:   {},
        )
      end

      assert_equal(
        "missing required argument(s) `album' when invoking method `required_keyword_argument' on #<TestMethodBank:0xdeadbeef>",
        error.message,
      )
    end

    def test_querying_required_keyword_argument
      method = Invokr.query_method TestMethodBank.method :required_keyword_argument

      assert_equal [:album], method.required_dependencies
    end
  end
end
