require 'r2'

describe R2 do

  describe ".r2" do
    let(:css_ltr) { File.read("spec/fixtures/ltr.css") }
    let(:css_rtl) { File.read("spec/fixtures/rtl.css") }
    let(:matcher) { /url[\s]*\([\s]*([^\)]*)[\s]*\)[\s]*/ }
    let(:handler) { Proc.new {|value, url| value.gsub('-ltr.', '-rtl.')} }
    let(:translator) { R2::Translator.new(matcher, handler) }

    it "flips css when sent css" do
      R2.r2(css_ltr, :translators => [translator]).should == css_rtl
    end

  end

end
