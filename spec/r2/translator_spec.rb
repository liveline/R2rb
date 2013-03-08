require 'r2/translator'

describe R2::Translator do
  let(:matcher) { /(foo)/ }
  let(:handler) { Proc.new {|value, match| value.gsub(match, 'bar')} }

  describe ".new" do
    context "with an invalid matcher" do
      it "should raise ArgumentError" do
        expect { R2::Translator.new(42, handler) }.to raise_error(ArgumentError, "matcher must respond to :match")
      end
    end

    context "with an invalid handler" do
      it "should raise ArgumentError" do
        expect { R2::Translator.new(matcher, 42) }.to raise_error(ArgumentError, "handler must respond to :call")
      end
    end
  end

  subject(:translator) { R2::Translator.new(matcher, handler) }

  its(:matcher) { should eq(matcher) }
  its(:handler) { should eq(handler) }

  describe "#transform" do
    context "with a non-matching value" do
      it "should return original value" do
        translator.transform("baz qux").should == "baz qux"
      end
    end

    context "with a matching value" do
      it "should return transformed value" do
        translator.transform("foo bar").should == "bar bar"
      end
    end
  end
end
