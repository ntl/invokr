Method = Struct.new :method do
  def invoke receiver = method.owner, hsh_args
    unless receiver == method.owner or receiver.kind_of? method.owner
      raise TypeError, "no implicit conversion of #{receiver.class} into #{method.owner.name}"
    end
    Invokr.invoke method: method.name, on: receiver, with: hsh_args
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

  def select_parameters_by_type types
    parameters.select do |type, _| types.include? type end
  end

  def map_identifiers parameters
    parameters.map do |_, identifier| identifier end
  end
end
