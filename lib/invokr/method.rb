module Invokr
  Method = Struct.new :method do
    def invoke args = {}
      receiver, method_name, hsh_args = extract_args! args
      unless receiver == method.owner or receiver.kind_of? method.owner
        raise TypeError, "no implicit conversion of #{receiver.class} into #{method.owner.name}"
      end
      invocation = Builder.build method, hsh_args, args[:block]
      invocation.method = method_name unless method_name == method.name
      invocation.invoke! receiver
    end

    def trim_args hsh_args
      hsh_args.select { |key, _| dependencies.include? key }
    end

    def dependencies
      map_identifiers parameters
    end

    def optional_dependencies
      map_identifiers select_parameters_by_type [:opt, :key]
    end

    def required_dependencies
      map_identifiers select_parameters_by_type [:req, :keyreq]
    end

    def parameters
      method.parameters
    end

    private

    def extract_args! args
      receiver = args.fetch :receiver do method.owner end
      method_name = args.fetch :method do method.name end
      with = args.fetch :with
      [receiver, method_name, with]
    end

    def select_parameters_by_type types
      parameters.select do |type, _| types.include? type end
    end

    def map_identifiers parameters
      parameters.map do |_, identifier| identifier end
    end
  end
end
