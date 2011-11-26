require 'spec_helper'

describe "assign" do
  include RSpec::Rails::Matchers::Assign

  subject { stub(:assigns => {:blah => "thing"}) }

  it { should_not assign :foo }
  it { should assign(:blah) }
  it { should assign(:blah).to == "thing" }
  it { should_not assign(:blah).to == "what" }
  it { should assign(:blah).to =~ /\Athi/ }
  it { should assign(:blah, "thing") }
  it { should_not assign(:blah, "what") }
  it { should assign(:blah).to "thing" }
  it { should_not assign(:blah).to "what" }
  it { should assign(:blah).to be_present  }
  it { should_not assign(:blah).to be_blank }
  it { should assign(:blah).to include "hin"  }
  it { should_not assign(:blah).to include "what "  }
end
