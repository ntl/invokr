require 'delegate'

module Invokr
  extend self

  def invoke args = {}
    if _proc = args.delete(:proc)
      invoke_proc _proc, args
    else
      invoke_method args
    end
  end

  def invoke_method args = {}
    method_name, obj, hsh_args = require_arguments! args, :method, :on, :with
    method = obj.method method_name
    invocation = Builder.build method, hsh_args, args[:block]
    invocation.invoke! obj
  end

  def invoke_proc _proc, args
    hsh_args = require_arguments! args, :with
    invocation = Builder.build _proc, hsh_args, args[:block]
    obj = SimpleDelegator.new _proc
    invocation.invoke! obj
  end

  def query_method method
    Method.new method
  end

  private

  def require_arguments! hsh, *args
    found_args, missing_args = args.partition do |arg|
      hsh.has_key? arg
    end
    raise InputError.new missing_args unless missing_args.empty?
    list = found_args.map { |arg| hsh.fetch arg }
    args.size == 1 ? list.first : list
  end
end

require_relative 'invokr/builder'
require_relative 'invokr/errors'
require_relative 'invokr/invocation'
require_relative 'invokr/method'
require_relative 'invokr/version'
