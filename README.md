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

## Todo

* Cleanup
* Use the `Invokr::Method` object within the `Invokr::Builder`.

## Pre-keyword argument hash defaults

Before ruby 2.x introduced keyword arguments, it was common to end your method signature with a default hash, e.g. `def my_method args = {}`. Invoker supports this by building a Hash out of all the unused arguments you passed in, and passing *that* into the optional argument.

## Dependency injection

One of the use cases for Invokr is building abstract factories. In this case, you want to inspect the method signature of `Object#initialize`, but actually pass `.new` to the class to have it allocate memory and invoke the initializer for you. Since this is a weird case, there's some support to make building a dependency injector much easier, just make sure you explictily `require "invokr/dependency_injection"` and then check out `test/dependency_injection_example_test.rb` for how it is used. Basically, your factory object just needs to implement a method called `resolve` that takes in the name of a dependency that maps to a parameter on the `#initialize` method for the class you're trying to build out.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/invokr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
