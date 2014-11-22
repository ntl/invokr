require 'ostruct'

class DependencyInjectionExampleTest < Minitest::Test
  def test_dependency_injection
    obj = Invokr.inject(
      TestObject,
      :using => {
        :album => 'farmhouse',
        :guitarist => 'trey',
        :drummer => 'fishman',
      },
    )

    assert_equal 'farmhouse', obj.album
    assert_equal 'trey', obj.guitarist
  end

  def test_injecting_a_proc
    my_proc = lambda { |foo,bar| OpenStruct.new foo: foo, bar: bar }

    obj = Invokr.inject(
      my_proc,
      :using => {
        :foo => 'bar',
        :bar => 'baz',
        :ping => 'pong',
      }
    )

    assert_equal 'bar', obj.foo
    assert_equal 'baz', obj.bar
  end

  def test_injecting_proc_duck_type
    obj = Invokr.inject(
      TestProcDuckType.new,
      :using => {
        :foo => 'FOO',
        :bar => 'BAZ',
      },
    )

    assert_equal 'FOO', obj.foo
    assert_equal 'BAZ', obj.bar
  end

  class TestObject
    attr :album, :guitarist

    def initialize album, guitarist = 'jimmy'
      @album = album
      @guitarist = guitarist
    end
  end

  class TestProcDuckType
    def parameters
      [[:req, :foo],[:req, :bar]]
    end

    def call(foo, bar)
      OpenStruct.new foo: foo, bar: bar
    end
  end
end
