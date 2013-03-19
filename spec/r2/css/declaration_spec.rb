require 'r2/css/declaration'

describe R2::CSS::Declaration do
  let(:stylesheet) { double("stylesheet", :translators => []) }
  let(:rule) { double("rule", :stylesheet => stylesheet) }
  subject(:declaration) { R2::CSS::Declaration }

  describe ".new" do

    it "should raise InvalidDeclaration when sent nil" do
      expect { declaration.new(rule, nil) }.to raise_error(R2::CSS::Declaration::InvalidDeclaration, "css argument can't be nil")
    end

    it "should raise InvalidDeclaration when sent invalid css" do
      expect { declaration.new(rule, "not a declaration") }.to raise_error(R2::CSS::Declaration::InvalidDeclaration, 'css argument "not a declaration" does not appear to be a valid CSS declaration')
    end

    it "should return Declaration instance when sent valid css" do
      declaration.new(rule, "direction:rtl").should be_instance_of R2::CSS::Declaration
    end

  end

  describe "instance" do

    let(:css) { "direction:ltr" }
    subject(:declaration) { R2::CSS::Declaration.new(rule, css) }

    its(:rule) { should == rule }
    its(:css)  { should == "direction: ltr;" }
    its(:to_s) { should == "direction: ltr;" }

    its(:property) { should == "direction" }
    its(:value)    { should == "ltr" }

  end

end
