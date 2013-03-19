require 'r2'
require 'r2/translation'

describe R2 do

  describe ".translate" do
    let(:css_american) { File.read("spec/fixtures/american.css") }
    let(:css_english)  { File.read("spec/fixtures/british.css") }

    it "does not translate when sent css without translations" do
      R2.translate(css_american).to_s.should == css_american
    end

    it "translates css when sent css and translations" do

      R2.translate(css_american) do

        match :property => /\bcolor\b/ do
          property.gsub!('color', 'colour')
        end

        match :property => /\bz-index\b/ do
          property.gsub!('z-index', 's-index')
        end

        match :value => /\bgray\b/ do
          value.gsub!('gray', 'grey')
        end

        match :value => /url[\s]*\([\s]*([^\)]*)[\s]*\)[\s]*/ do
          value.gsub!('burger.jpg', 'nice-cup-of-tea.jpg')
        end

      end.to_s.should == css_english

    end

  end

  describe ".r2" do
    let(:css_ltr) { File.read("spec/fixtures/ltr.css") }
    let(:css_rtl) { File.read("spec/fixtures/rtl.css") }
    let(:css_rtl_with_images) { File.read("spec/fixtures/rtl-with-images.css") }

    it "translates css to RTL when sent LTR css" do
      R2.r2(css_ltr).to_s.should == css_rtl
    end

    it "translates css to RTL when sent LTR css with custom translations" do

      R2.r2(css_ltr) do
        match :value => /url[\s]*\([\s]*([^\)]*)[\s]*\)[\s]*/ do
          value.gsub!('.png', '-rtl.png')
        end
      end.to_s.should == css_rtl_with_images

    end

  end

end
