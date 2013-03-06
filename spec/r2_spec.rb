require 'r2'

describe R2 do

  describe ".r2" do
    let(:r2)  { double("r2") }
    let(:css) { "body { direction: rtl; }" }

    it "provides a shortcut to .new#r2" do
      R2::Swapper.should_receive(:new).and_return(r2)
      r2.should_receive(:r2).with(css)
      R2.r2(css)
    end
  end

end
