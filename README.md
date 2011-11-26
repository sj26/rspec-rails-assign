# RSpec Rails Assign

## Motivation

This is ugly:

```ruby
subject { get :show }
specify { subject and assigns[:blah].should be_present }
specify { subject and assigns[:blah].should be_a String }
specify { subject and assigns[:blah].should == "something" }
```

Instead:

```ruby
subject { get :show }
it { should assign(:blah) }
it { should assign(:blah).to == "something" }
it { should assign(:blah).to be_a String }
```

It's more like a subject modifier, a la `its`, but inline and allowing nicely described specs:

```
MyController
  #show
    should assign @blah
    should assign @blah to == "something"
    should assign @blah to be a kind of String
```

And presents nice diffs when it fails:

```
  1) MyController#show assign @blah to == "something"
     Failure/Error: it { should assign(:blah).to == "something" }
       expected #<String:2533082340> => "something"
            got #<String:2532866800> => "thing"
```

I'm not sold on `to` but I couldn't think of something that fits `should`/`should_not` and `be`/`be_a`/etc, plus `expect` sets a precedent of `to`.

I also don't like that it feels a bit WET, but I couldn't use these bits nicely out of rspec.

## License

The MIT License, see [LICENSE][license].
