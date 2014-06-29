module Invokr
  extend self

  def invoke args = {}
    method_name, obj, hsh_args = require_arguments! args, :method, :on, :with
    method = obj.method method_name
    invocation = Builder.build method, hsh_args, args[:block]
    invocation.invoke! obj
  end

  def query_method method
    Method.new method
  end

  Method = Struct.new :method do
    def invoke receiver = method.owner, hsh_args
      unless receiver == method.owner or receiver.kind_of? method.owner
        raise TypeError, "no implicit conversion of #{receiver.class} into #{method.owner.name}"
      end
      Invokr.invoke method: method.name, on: receiver, with: hsh_args
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

  private

  def require_arguments! hsh, *args
    found_args, missing_args = args.partition do |arg|
      hsh.has_key? arg
    end
    raise InputError.new missing_args unless missing_args.empty?
    found_args.map { |arg| hsh.fetch arg }
  end
end

require_relative 'invokr/builder'
require_relative 'invokr/errors'
require_relative 'invokr/invocation'
require_relative 'invokr/version'
