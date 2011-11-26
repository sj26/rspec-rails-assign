require 'spec_helper'

module RSpec::Rails::Matchers::Assign
  private

  # +nodoc+
  class AssignMatcher
    attr_accessor :actual, :operator, :expected

    def initialize scope, name, expected=nil
      @scope = scope
      @name = name
      @actual = nil
      @operator = :==
      @expected = [expected]
    end

    def description
      "assign @#{@name}#{" to #{@operator} #{@expected.first.inspect}" if @expected.first}"
    end

    def failure_message_for_should
      if @expected.first.nil?
        "expected to assign @#{@name}"
      elsif ['==','===', '=~'].include?(operator)
        "expected: #{expected.first.inspect}\n     got: #{actual.inspect} (using #{operator})"
      else
        "expected: #{operator} #{expected.first.inspect}\n     got: #{operator.gsub(/./, ' ')} #{actual.inspect}"
      end
    end

    def failure_message_for_should_not
      if @expected.first.nil?
        "expected not to assign @#{@name}"
      else
        "expected not: #{operator} #{expected.first.inspect}\n         got: #{operator.gsub(/./, ' ')} #{actual.inspect}"
      end
    end

    def diffable?
      true
    end

    def to matcher_or_expected=nil
      # Operator matchers, we need to get tricky!
      if matcher_or_expected.nil?
        AssignOperator.new self
      # Meta-matching
      elsif matcher_or_expected.respond_to? :matches?
        AssignMetaMatcher.new @scope, @name, matcher_or_expected
      # Just a value, set expected
      else
        @expected = [matcher_or_expected]
        self
      end
    end

    def matches? actual
      @actual = actual.assigns[@name]

      if @expected.first.nil?
        @actual.present?
      else
        @actual.send @operator, @expected.first
      end
    end
  end

  # +nodoc+
  class AssignOperator
    def initialize matcher
      @matcher = matcher
    end

    ['==', '===', '=~', '>', '>=', '<', '<='].each do |operator|
      define_method operator do |expected|
        @matcher.operator = operator
        @matcher.expected = [expected]
        @matcher
      end
    end
  end

  # +nodoc+
  class AssignMetaMatcher
    def initialize scope, name, matcher
      @scope = scope
      @name = name
      @matcher = matcher
    end

    def matches? actual
      @actual = actual.assigns[@name]
      @matcher.matches? @actual
    end

    def description
      "assign @#{@name} to #{@matcher.description}"
    end

    def method_missing name, *args, &block
      @matcher.send name, *args, &block
    end
  end

  public

  # Lets you write:
  #
  #      subject { get :show }
  #      it { should assign(:blah) }
  #      it { should assign(:blah).to("something") }
  #
  # or, more interestingly:
  #
  #      it { should assign(:blah).to == "something" }
  #      it { should assign(:blah).to be_a String }
  #      it { should assign(:blah).to satisfy { |value| Thing.exists? :blah => value } }
  #
  def assign *args, &block
    AssignMatcher.new self, *args, &block
  end
end
