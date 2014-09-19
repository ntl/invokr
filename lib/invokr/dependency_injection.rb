module Invokr
  module DependencyInjection
    extend self

    def inject obj, using
      meth = case obj
             when -> (obj) { obj.respond_to?(:call) } then :inject_proc
             when Class then :inject_klass
             else raise ArgumentError, "can't inject #{obj.inspect}"
             end
      resolver = build_resolver using
      send meth, obj, resolver
    end

    private

    def build_resolver using
      if using.is_a? Hash
        HashResolver.new using
      else
        using
      end
    end

    def inject_klass klass, resolver
      injector = KlassInjector.new resolver, klass
      injector.inject
    end

    def inject_proc proc, resolver
      injector = ProcInjector.new resolver, proc
      injector.inject
    end

    Injector = Struct.new :resolver, :obj do
      def keys
        method.parameters.map { |_, identifier| identifier }
      end

      def fetch arg, &default
        resolver.resolve arg, &default
      end

      def has_key? arg
        resolver.could_resolve? arg
      end
    end

    class KlassInjector < Injector
      def inject
        _method = Invokr.query_method method
        _method.invoke :method => :new, :receiver => obj, :with => self
      end

      def method
        obj.instance_method :initialize
      end
    end

    class ProcInjector < Injector
      def inject
        Invokr.invoke :proc => obj, :with => self
      end

      def method
        obj
      end
    end

    class HashResolver
      def initialize hsh
        @hsh = hsh
      end

      def inject klass
        DependencyInjection.inject(
          :klass => klass,
          :using => self,
        )
      end

      def resolve val, &block
        @hsh.fetch val, &block
      end

      def could_resolve? val
        @hsh.has_key? val
      end
    end
  end
end
