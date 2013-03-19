require 'r2/translators'

describe R2::Translators do

  describe ".direction_swap" do
    it "should swap 'rtl' to 'ltr'" do
      R2::Translators.direction_swap('rtl').should == 'ltr'
    end

    it "should swap 'ltr' to 'rtl'" do
      R2::Translators.direction_swap('ltr').should == 'rtl'
    end

    it "should ignore values other than 'ltr' and 'rtl'" do
      [nil, '', 'foo'].each do |val|
        R2::Translators.direction_swap(val).should == val
      end
    end
  end

  describe ".side_swap" do
    it "should swap 'right' to 'left'" do
      R2::Translators.side_swap('right').should == 'left'
    end

    it "should swap 'left' to 'right'" do
      R2::Translators.side_swap('left').should == 'right'
    end

    it "should ignore values other than 'left' and 'right'" do
      [nil, '', 'foo'].each do |val|
        R2::Translators.side_swap(val).should == val
      end
    end
  end

  describe ".edge_swap" do
    it "should swap a quad value" do
      R2::Translators.edge_swap("1px 2px 3px 4px").should == "1px 4px 3px 2px"
    end

    it "should skip a pair value" do
      R2::Translators.edge_swap("1px 2px").should == "1px 2px"
    end
  end

  describe ".corner_swap" do
    it "should swap a quad value" do
      R2::Translators.corner_swap("1px 2px 3px 4px").should == "2px 1px 4px 3px"
    end

    it "should swap a triple value" do
      R2::Translators.corner_swap("1px 2px 3px").should == "2px 1px 2px 3px"
    end

    it "should swap a pair value" do
      R2::Translators.corner_swap("1px 2px").should == "2px 1px"
    end
  end

  describe ".position_swap" do

    context "with a single value" do
      it "should ignore a named-vertical" do
        R2::Translators.position_swap('top').should == 'top'
      end

      it "should swap a named-horizontal 'left'" do
        R2::Translators.position_swap('left').should == 'right'
      end

      it "should swap a named-horizontal 'right'" do
        R2::Translators.position_swap('right').should == 'left'
      end

      it "should invert a percentage" do
        R2::Translators.position_swap('25%').should == '75%'
      end

      it "should convert a unit value" do
        R2::Translators.position_swap('25px').should == 'right 25px center'
      end
    end

    context "with a pair of values" do
      # Note that a pair of keywords can be reordered while a combination of
      # keyword and length or percentage cannot. So ‘center left’ is valid
      # while ‘50% left’ is not.
      # See: http://dev.w3.org/csswg/css3-background/#background-position

      it "should swap named-horizontal and ignore named-vertical" do
        R2::Translators.position_swap('right bottom').should == 'left bottom'
      end

      it "should swap named-horizontal and ignore unit-vertical" do
        R2::Translators.position_swap('left 100px').should == 'right 100px'
      end

      it "should convert unit-horizontal" do
        R2::Translators.position_swap('100px center').should == 'right 100px center'
      end

      it "should swap named-horizontal and ignore percentage-vertical" do
        R2::Translators.position_swap('left 0%').should == 'right 0%'
      end

      it "should invert first percentage-horizontal value in a pair" do
        R2::Translators.position_swap('25% 100%').should == '75% 100%'
      end
    end

    context "with a triplet of values" do
      it "should swap named-horizontal" do
        R2::Translators.position_swap('left 20px center').should == 'right 20px center'
      end
    end

    context "with a quad of values" do
      it "should swap named-horizontal value" do
        R2::Translators.position_swap('bottom 10px left 20px').should == 'bottom 10px right 20px'
      end
    end
  end

end
