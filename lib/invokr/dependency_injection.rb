module Invokr
  module DependencyInjection
    def self.inject args = {}
      klass = args.fetch :klass
      resolver = args.fetch :using
      injector = Injector.new resolver, klass
      injector.inject
    end

    Injector = Struct.new :resolver, :klass do
      def inject
        method = Invokr.query_method klass.instance_method :initialize
        method.invoke method: :new, with: self
      end

      def keys
        initializer.parameters.map { |_, identifier| identifier }
      end

      def fetch arg, &default
        resolver.resolve arg, &default
      end

      def initializer
        klass.instance_method :initialize
      end
    end
  end
end
