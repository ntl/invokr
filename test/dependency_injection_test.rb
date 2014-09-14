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
    my_proc = -> foo do OpenStruct.new foo: foo end

    obj = Invokr.inject(
      my_proc,
      :using => {
        :foo => 'bar',
        :ping => 'pong',
      }
    )

    assert_equal 'bar', obj.foo
  end

  class TestObject
    attr :album, :guitarist

    def initialize album, guitarist: 'jimmy'
      @album = album
      @guitarist = guitarist
    end
  end
end
