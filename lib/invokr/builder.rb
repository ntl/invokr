module Invokr
  class Builder
    def self.build *args
      builder = new *args
      builder.build
    end

    attr :argument_names, :injector, :method, :missing_args, :unused_args

    def initialize method, injector, implicit_block
      @argument_names = method.parameters.map &:last
      @injector = injector
      @method = method
      @opt_arg_name = nil

      @block_arg = nil
      @implicit_block = implicit_block
      @keyword_args = {}
      @positional_args = []
      @missing_args = []

      set_unused_args
    end

    def build
      handle_args!
      check_for_unused_args!
      check_for_missing_args!
      build_invocation
    end

    def build_invocation
      @block_arg = @implicit_block if @implicit_block
      if method.is_a? Proc
        Invocation.new :call, @positional_args, @keyword_args, @block_arg
      else
        Invocation.new method.name, @positional_args, @keyword_args, @block_arg
      end
    end

    def handle_args!
      method.parameters.each do |type, identifier|
        send "handle_#{type}_arg", identifier
      end
    end

    def handle_req_arg identifier
      arg = injector.fetch identifier do missing_argument! identifier end
      @positional_args << arg
    end

    def handle_opt_arg identifier
      optional_arg_error! identifier if hit_opt_arg?
      @opt_arg_name = identifier
      arg = injector.fetch identifier do
        build_hash_from_extra_args or return
      end
      @positional_args << arg
    end

    def handle_keyreq_arg identifier
      arg = injector.fetch identifier do missing_argument! identifier end
      @keyword_args[identifier] = arg
    end

    def handle_key_arg identifier
      return unless injector.has_key? identifier
      @keyword_args[identifier] = injector[identifier]
    end

    def handle_rest_arg identifier
      raise UnsupportedArgumentsError.new(self, [identifier])
    end
    alias_method :handle_keyrest_arg, :handle_rest_arg

    def handle_block_arg identifier
      if injector.has_key? identifier and @implicit_block
        unused_args << identifier and return
      end
      @block_arg = injector.fetch identifier do
        @implicit_block or missing_argument! identifier
      end
    end

    def hit_opt_arg?
      @opt_arg_name ? true : false
    end

    def set_unused_args
      @unused_args = injector.keys.flat_map do |hsh_arg|
        argument_names.include?(hsh_arg) ? [] : [hsh_arg]
      end
    end

    def build_hash_from_extra_args
      return nil if unused_args.empty?
      hsh = {}
      unused_args.each do |arg| hsh[arg] = injector.fetch arg end
      unused_args.clear
      hsh
    end

    def check_for_unused_args!
      return if unused_args.empty?
      raise ExtraArgumentsError.new self, unused_args
    end

    def check_for_missing_args!
      return if missing_args.empty?
      raise MissingArgumentsError.new self, missing_args
    end

    def optional_arg_error! identifier
      raise OptionalPositionalArgumentError.new(
        method.name,
        @opt_arg_name,
        identifier,
      )
    end

    def missing_argument! identifier
      missing_args << identifier
    end
  end
end
