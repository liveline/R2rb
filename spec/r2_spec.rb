require 'r2'

describe R2 do

  describe ".r2" do
    let(:css_ltr) { File.read("spec/fixtures/ltr.css") }
    let(:css_rtl) { File.read("spec/fixtures/rtl.css") }

    it "flips css when sent css" do
      R2.r2(css_ltr).should == css_rtl
    end
  end

end
