require 'spec_helper'

module RSpec::Rails::Matchers::Assign
  private

  # +nodoc+
  class AssignMatcher
    attr_accessor :actual, :operator, :expected

    def initialize scope, name, expected=nil
      @scope = scope
      @actual = nil

      if name.is_a? Hash
        raise ArgumentError, "must test at least one assignment" unless name.size
        raise ArgumentError, "can only test one assign at a time" if name.size > 1

        @name, expected = name.first
      else
        @name = name
      end

      @expected = [expected]
      @operator = nil
    end

    def description
      if @expected.first.nil?
        "assign @#{@name}"
      elsif @expected.first.respond_to? :matches?
        "assign @#{@name} to #{@expected.first.description}"
      else
        "assign @#{@name} #{@operator} #{@expected.first.inspect}"
      end
    end

    def failure_message_for_should
      if @expected.first.nil?
        "expected to assign @#{@name}"
      elsif ['==','===', '=~'].include?(operator)
        "expected: #{expected.first.inspect}\n     got: #{actual.inspect} (using #{operator})"
      elsif @expected.first.respond_to? :matches?
        "expected: #{actual.inspect} to #{@expected.first.description}"
      else
        "expected: #{operator} #{expected.first.inspect}\n     got: #{operator.gsub(/./, ' ')} #{actual.inspect}"
      end
    end

    def failure_message_for_should_not
      if @expected.first.nil?
        "expected not to assign @#{@name}"
      elsif @expected.first.respond_to? :matches?
        "expected: #{actual.inspect} to not #{@expected.first.description}"
      else
        "expected not: #{operator} #{expected.first.inspect}\n         got: #{operator.gsub(/./, ' ')} #{actual.inspect}"
      end
    end

    def diffable?
      not (@expected.first.is_a?(Regexp) or @expected.first.respond_to? :matches?)
    end

    def matches? actual
      @actual = actual.assigns[@name]

      if @expected.first.nil?
        @actual.present?
      elsif @operator
        @actual.send @operator, @expected.first
      elsif @expected.first.is_a? Regexp
        @operator = "=~"
        @actual =~ @expected.first
      elsif @expected.first.respond_to? :matches?
        @expected.first.matches? @actual
      else
        @operator = "=="
        @actual == @expected.first
      end
    end

    ['==', '===', '=~', '>', '>=', '<', '<='].each do |operator|
      define_method operator do |expected|
        raise ArgumentError, "can't use expected value and an opertator" if @expected.present?
        @operator = operator
        @expected = [expected]
        self
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
  #      it { should assign(:blah =>"something") }
  #
  # or, more interestingly:
  #
  #      it { should assign(:blah) == "something" }
  #      it { should assign(:blah => is_a(String)) }
  #      it { should assign(:blah => satisfy { |value| Thing.exists? :blah => value }) }
  #
  def assign *args, &block
    AssignMatcher.new self, *args, &block
  end

  def method_missing(method, *args, &block)
    # Allow infinitive forms of `be_<predicate>` matchers.
    return ::RSpec::Matchers::BePredicate.new(method.to_s.sub("is", "be"), *args, &block) if method.to_s =~ /\Ais_(.*)\Z/
    super
  end
end
