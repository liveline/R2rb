require 'r2/css/rule'

describe R2::CSS::Rule do
  subject(:rule) { R2::CSS::Rule }

  describe ".new" do

    it "should raise InvalidRule when sent nil" do
      expect { rule.new(nil) }.to raise_error(R2::CSS::Rule::InvalidRule, "css argument can't be nil")
    end

    it "should raise InvalidRule when sent invalid css" do
      expect { rule.new("not a rule") }.to raise_error(R2::CSS::Rule::InvalidRule, 'css argument "not a rule" does not appear to be a valid CSS rule')
    end

    it "should return Rule instance when sent valid css" do
      rule.new("html{direction:rtl;}").should be_instance_of R2::CSS::Rule
    end

  end

  describe "instance" do
    let(:css) { "html{direction:ltr;margin-left:10px;}" }
    subject(:rule) { R2::CSS::Rule.new(css) }

    its(:css) { should == css }

    its(:selector) { should == "html" }

    describe "#declarations" do
      subject(:declarations) { rule.declarations }

      it "should be an Array" do
        should be_instance_of Array
      end

      it "should contain 2 items" do
        subject.size.should == 2
      end

      describe "items" do

        it "should be R2::CSS::Declaration instances" do
          subject.each do |declaration|
            declaration.should be_instance_of R2::CSS::Declaration
          end
        end

      end

    end

    its(:to_s) { should == "html {\n  direction: ltr;\n  margin-left: 10px;\n}" }

  end

end
