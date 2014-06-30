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

  def test_invoking_singleton_from_query_object
    assert_equal ['junta', 'trey'], @method.invoke(album: 'junta')
  end

  def test_invoking_instance_from_query_object
    test_klass = define_test_klass
    method = Invokr.query_method test_klass.instance_method :upcase

    val = method.invoke test_klass.new, dep: 'phIsh'
    assert_equal "PHISH", val
  end

  def test_cannot_invoke_instance_not_type_other_than_method_owner
    test_klass = define_test_klass
    method = Invokr.query_method test_klass.instance_method :upcase

    error = assert_raises TypeError do
      method.invoke Array.new, dep: 'phIsh'
    end

    assert_equal 'no implicit conversion of Array into TestKlass', error.message
  end

  def test_trimming_arguments
    hsh = { album: 'junta', guitarist: 'trey', drummer: 'phish' }
    assert_equal %i(album guitarist), @method.trim_args(hsh).keys
  end

  private

  def define_test_klass
    Class.new do
      def self.name
        'TestKlass'
      end

      def upcase dep
        dep.upcase
      end
    end
  end
end
