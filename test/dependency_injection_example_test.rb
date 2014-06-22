require 'invokr/dependency_injection'

class DependencyInjectionExampleTest < Minitest::Test
  def setup
    @injector = TestInjector.new(
      :album => 'farmhouse',
      :guitarist => 'trey',
      :drummer => 'fishman',
    )
  end

  def test_dependency_injection
    @injector.inject TestObject
  end

  class TestInjector
    def initialize hsh
      @hsh = hsh
    end

    def inject klass
      Invokr::DependencyInjection.inject(
        :klass => klass,
        :using => self,
      )
    end

    def resolve val
      @hsh.fetch val
    end
  end

  class TestObject
    attr :album, :guitarist

    def initialize album, guitarist
      @album = album
      @guitarist = guitarist
    end
  end
end
