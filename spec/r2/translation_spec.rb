require 'r2/translation'

describe R2::Translation do

  describe ".new" do
    context "with an invalid matcher key" do
      it "should raise ArgumentError" do
        expect {
          R2::Translation.new(:foo => /bar/) do
            value.gsub!('bar', 'pub')
          end
        }.to raise_error(ArgumentError, "matcher keys must be :property or :value")
      end
    end

    context "with an invalid matcher value" do
      it "should raise ArgumentError" do
        expect {
          R2::Translation.new(:value => 42) do
            value.gsub!('bar', 'pub')
          end
        }.to raise_error(ArgumentError, "matchers must respond to :match")
      end
    end

    context "with an invalid handler" do
      it "should raise ArgumentError" do
        expect {
          R2::Translation.new(:value => 'bar')
        }.to raise_error(ArgumentError, "no translator block given")
      end
    end
  end

  describe "instance" do
    let(:matchers) { {:value => 'bar'} }
    subject(:translation) do
      R2::Translation.new(matchers) do
        value.gsub!('bar', 'pub')
      end
    end

    its(:matchers) { should eq(matchers) }
    its(:translator) { should be_instance_of(Proc) }

    describe "#translate" do
      let(:stylesheet) { double("stylesheet", :translations => []) } # TODO: Not have to do this
      let(:rule) { double("rule", :stylesheet => stylesheet) } # TODO: Not have to do this
      let(:declaration) { R2::CSS::Declaration.new(rule, "color:red") }

      context "with a property Translation" do
        subject(:translation) do
          R2::Translation.new(:property => /color/) do
            property.gsub!('color', 'colour')
          end
        end

        it "should translate Declaration property" do
          translation.translate(declaration).property.should == 'colour'
        end

      end

      context "with a value Translation" do

        subject(:translation) do
          R2::Translation.new(:value => /red/) do
            value.gsub!('red', 'green')
          end
        end

        it "should translate Declaration value" do
          translation.translate(declaration).value.should == 'green'
        end

      end

    end

  end

end
