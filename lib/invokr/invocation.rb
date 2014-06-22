module Invokr
  Invocation = Struct.new :method, :positional_args, :keyword_args, :block_arg do
    def invoke! obj
      if block_arg?
        obj.public_send method, *args, &block_arg
      else
        obj.public_send method, *args
      end
    end

    def block_arg?
      block_arg ? true : false
    end

    def args
      args = positional_args.dup
      args << keyword_args unless keyword_args.empty?
      args
    end
  end

end
