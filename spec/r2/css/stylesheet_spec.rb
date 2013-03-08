require 'r2/css/stylesheet'

describe R2::CSS::Stylesheet do
  let(:css_ltr) { File.read("spec/fixtures/ltr.css") }
  let(:matcher) { /url[\s]*\([\s]*([^\)]*)[\s]*\)[\s]*/ }
  let(:handler) { Proc.new {|value, url| value.gsub('-ltr.', '-rtl.')} }
  let(:translator) { R2::Translator.new(matcher, handler) }
  subject(:stylesheet) { R2::CSS::Stylesheet }

  describe ".new" do

    it "should raise InvalidStylesheet when sent nil" do
      expect { stylesheet.new(nil) }.to raise_error(R2::CSS::Stylesheet::InvalidStylesheet, "css argument can't be nil")
    end

    it "should raise InvalidStylesheet when sent invalid css" do
      expect { stylesheet.new("not a stylesheet") }.to raise_error(R2::CSS::Stylesheet::InvalidStylesheet, 'no CSS rules found')
    end

    it "should return Stylesheet instance when sent valid css" do
      stylesheet.new(css_ltr).should be_instance_of R2::CSS::Stylesheet
    end

    context "with translators instance" do
      subject { stylesheet.new(css_ltr, :translators => translator) }
      its(:translators) { should eq([translator]) }
    end

    context "with translators array" do
      subject { stylesheet.new(css_ltr, :translators => [translator]) }
      its(:translators) { should eq([translator]) }
    end

  end

  describe "instance" do
    subject(:stylesheet) { R2::CSS::Stylesheet.new(css_ltr) }

    its(:css) { should == css_ltr }

    describe "#rules" do
      subject(:rules) { stylesheet.rules }

      it "should be an Array" do
        should be_instance_of Array
      end

      it "should contain 2 items" do
        subject.size.should == 2
      end

      describe "items" do

        it "should be R2::CSS::Rule instances" do
          subject.each do |rule|
            rule.should be_instance_of R2::CSS::Rule
          end
        end

      end

    end

    its(:to_s) { should == css_ltr }

    describe "#minimize" do
      it "should handle nil" do
        stylesheet.send(:minimize, nil).should == ""
      end

      it "should strip comments" do
        stylesheet.send(:minimize, "/* comment */foo").should == "foo"
      end

      it "should remove newlines" do
        stylesheet.send(:minimize, "foo\nbar").should == "foobar"
      end

      it "should remove carriage returns" do
        stylesheet.send(:minimize, "foo\rbar").should == "foobar"
      end

      it "should collapse multiple spaces into one" do
        stylesheet.send(:minimize, "foo       bar").should == "foo bar"
      end
    end

  end

end
