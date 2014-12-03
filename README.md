# Invokr

Invoke methods with a consistent Hash interface. Useful for metaprogramming.

## Basic Usage

Let's say you've got a method you want to call:

```ruby
class BankAccount
  def add_transaction(amount, account_id:, description: '')
    # adds transaction
  end
end
```

You can invoke this method through the class interface with pure ruby. But sometimes you've got a Hash containing the parameters. This is where Invokr comes in:

```ruby
bank_account = BankAccount.new
params = JSON.parse http_request.response_body
Invokr.invoke method: :add_transaction, on: bank_account, with: params
```

Behind the scenes, Invokr figured out how to translate that `Hash` into a method signature compatible with `BankAccount#add_transaction`.

You can also pass in procs to invokr:

```ruby
my_proc = ->|a,b| { a + b }
Invokr.invoke proc: my_proc, with: { a: 2, b, 4 }
```

## Using vs. With

If you supply arguments that the method doesn't know how to handle, an `Invokr::ExtraArgumentsError` is raised. This is because, in general, you can't supply extra arguments to a plain old ruby method. However, from time to time we want to be able to pass in extra arguments. You can use the `using` keyword in order to simulate the behavior of the splat (`*`) operator:

```ruby
Invokr.invoke method: :add_transaction, on: bank_account, with: { amount: 12.34, account_id: 24, extra_arg: 'hey, there' }
```

## Querying 

Want to investigate the arguments of a method?

```ruby
meth = Invokr.query_method bank_account.method(:add_transaction)
```

This will return an object that you can use to inspect the optional/required dependencies of a method:

```ruby
meth.required_dependencies
=> [:amount, :account_id]
meth.optional_dependencies
=> [:description]
```

## Limitations

Currently, more than one optional positional argument isn't supported. Consider:

```ruby
def my_method arg1 = 'foo', arg2 = 'bar'
end
```

Without knowing how to parse the source code for `#my_method`, Invokr couldn't know what the default values are. And even if I brought in e.g. [ruby_parser](https://github.com/seattlerb/ruby_parser), I'd have to support lazy evaluation, for when you supply a method or constant as the default. This complexity is completely unneccessary when using keyword arguments, so I suggest using that approach for multiple defaults for now.

## Pre-keyword argument hash defaults

Before ruby 2.x introduced keyword arguments, it was common to end your method signature with a default hash, e.g. `def my_method args = {}`. Invoker supports this by building a Hash out of all the unused arguments you passed in, and passing *that* into the optional argument.

## Dependency injection

One of the use cases for Invokr is building abstract factories. In this case, you want to inspect the method signature of `Object#initialize`, but actually pass `.new` to the class to have it allocate memory and invoke the initializer for you. Check out `test/dependency_injection_example_test.rb` for how it is used. You can use a hash to serve as the registry of objects, or build your own custom resolver. Here's an example supplying a Hash as the registry:

```ruby
class MyKlass
  attr :foo, :bar
  def initiailze foo, bar
    @foo, @bar = foo, bar
  end
end

Invokr.inject MyKlass, using: { foo: 'FOO', bar: 'BAR', baz: 'BAZ' }
```

Even though `MyKlass` doesn't depend on `baz`, because everything it *did* need was present in the `using` Hash, Invokr was able to instantiate an instance of `MyKlass`

## Todo

* Cleanup
* Use the `Invokr::Method` object within the `Invokr::Builder`.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/invokr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
