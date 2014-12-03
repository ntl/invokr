require 'delegate'

require_relative 'invokr/builder'
require_relative 'invokr/dependency_injection'
require_relative 'invokr/errors'
require_relative 'invokr/invocation'
require_relative 'invokr/method'
require_relative 'invokr/version'

module Invokr
  extend self

  def invoke args = {}
    if _proc = args.delete(:proc)
      invoke_proc _proc, args
    else
      invoke_method args
    end
  end

  def inject obj, args = {}
    using = require_arguments! args, :using
    DependencyInjection.inject obj, using
  end

  def query_method method
    Method.new method
  end

  private

  def invoke_method args = {}
    method_name, obj, hsh_args = require_arguments! args, :method, :on, [:with, :using]
    allow_unused = args.has_key? :using
    method = obj.method method_name
    invocation = Builder.build method, hsh_args, args[:block], allow_unused
    invocation.invoke! obj
  end

  def invoke_proc _proc, args = {}
    hsh_args = require_arguments! args, [:with, :using]
    allow_unused = args.has_key? :using
    invocation = Builder.build _proc, hsh_args, args[:block], allow_unused
    obj = SimpleDelegator.new _proc
    invocation.invoke! obj
  end

  def require_arguments! hsh, *args
    found_args, missing_args = args.partition do |arg|
      Array(arg).any? &hsh.method(:has_key?)
    end
    raise InputError.new missing_args unless missing_args.empty?
    list = found_args.map do |arg|
      pair = hsh.detect do |k,_| Array(arg).include? k end
      pair.fetch 1
    end
    args.size == 1 ? list.first : list
  end
end
