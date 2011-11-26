# RSpec Rails Assign

## Motivation

This is ugly:

```ruby
subject { get :show }
specify { subject and assigns[:blah].should be_present }
specify { subject and assigns[:blah].should == "something" }
specify { subject and assigns[:blah].should =~ /thi/ }
specify { subject and assigns[:blah].should is_a String }
```

Instead:

```ruby
subject { get :show }
it { should assign :blah }
it { should assign :blah => "something" }
it { should assign :blah => /thi/ }
it { should assign :blah => is_a_(String) }
```

It's more like a subject modifier, a la `its`, but inline and allowing nicely described specs:

```
MyController
  #show
    should assign @blah
    should assign @blah == "something"
    should assign @blah =~ /thi/
    should assign @blah to be a kind of String
```

And presents nice diffs when it fails:

```
  1) MyController#show assign @blah to == "something"
     Failure/Error: it { should assign :blah => "something" }
       expected: "something"
            got: "other" (using ==)
```

## License

The MIT License, see [LICENSE][license].
