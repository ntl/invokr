module Invokr
  class InputError < ArgumentError
    attr :missing_args

    def initialize missing_args
      @missing_args = missing_args
      missing_args.map! do |arg| "`#{arg}'" end
    end

    def message
      @message ||= build_message
    end

    def build_message
      prefix = "cannot invoke; missing required arguments: "
      prefix << concat_missing_args
      prefix
    end

    def concat_missing_args
      return missing_args.first if missing_args.size == 1
      last_arg = missing_args.pop
      "#{missing_args.join ', '} and #{last_arg}"
    end
  end

  class BadArgumentsError < ArgumentError
    attr :builder, :args

    def initialize builder, args
      @builder = builder
      @args = args
    end

    def formatted_args
      args.map { |arg| "`#{arg}'" }.join ', '
    end
  end

  class ExtraArgumentsError < BadArgumentsError
    def message
      %(unused argument(s) #{formatted_args} when invoking method `#{builder.method.name}' on #{builder.method.owner.inspect})
    end
  end

  class MissingArgumentsError < BadArgumentsError
    def message
      %(missing required argument(s) #{formatted_args} when invoking method `#{builder.method.name}' on #{builder.method.owner.inspect})
    end
  end

  class UnsupportedArgumentsError < BadArgumentsError
    def message
      %(unsupported splat argument(s) #{formatted_args} when invoking method `#{builder.method.name}' on #{builder.method.owner.inspect})
    end
  end

  class OptionalPositionalArgumentError < StandardError
    attr :message

    def initialize method, arg1, arg2
      @message = <<-MESSAGE
method `#{method}' has optional positional argument `#{arg2}', after optional argument `#{arg1}'.

We cannot use this method because there's no way to supply an explicit value for `#{arg2}' without knowing the default value for `#{arg1}'. It's technically possible to overcome this with S-expression analysis, but a much simpler solution would be to use keyword arguments.
      MESSAGE
    end
  end
end
