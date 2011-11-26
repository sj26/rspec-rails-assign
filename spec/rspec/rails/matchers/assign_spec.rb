require 'spec_helper'

describe "assign" do
  include RSpec::Rails::Matchers::Assign

  subject { stub(:assigns => {:blah => "thing"}) }

  it { should_not assign :foo }
  it { should assign :blah }
  it { should assign :blah => "thing" }
  it { should_not assign :blah => "what" }
  it { should assign :blah => /\Athi/ }
  it { should_not assign :blah => /what/ }
  it { should assign :blah => is_present  }
  it { should_not assign :blah => is_blank }
  it { should assign :blah => include("hin")  }
  it { should_not assign :blah => include("what") }
end
