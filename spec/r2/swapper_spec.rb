require 'r2/swapper'

describe R2::Swapper do
  subject(:swapper) { R2::Swapper.new }

  describe "#r2" do
    it "processes CSS" do
      swapper.r2("/* comment */\nbody { direction: rtl; }\nimg { padding: 4px;}").should == "body{direction:ltr;}img{padding:4px;}"
    end
  end

  describe "#declaration_swap" do
    it "should handle nil" do
      swapper.declaration_swap(nil).should == ''
    end

    it "should handle invalid declarations" do
      swapper.declaration_swap("not a decl").should == ''
    end

    it "should swap a swappable parameter" do
      swapper.declaration_swap("padding-right:4px").should == 'padding-left:4px;'
    end

    it "should swap a swappable quad parameter" do
      swapper.declaration_swap("padding:1px 2px 3px 4px").should == 'padding:1px 4px 3px 2px;'
    end

    it "should ignore other parameters" do
      swapper.declaration_swap("foo:bar").should == 'foo:bar;'
    end
  end

  describe "#minimize" do
    it "should handle nil" do
      swapper.minimize(nil).should == ""
    end

    it "should strip comments" do
      swapper.minimize("/* comment */foo").should == "foo"
    end

    it "should remove newlines" do
      swapper.minimize("foo\nbar").should == "foobar"
    end

    it "should remove carriage returns" do
      swapper.minimize("foo\rbar").should == "foobar"
    end

    it "should collapse multiple spaces into one" do
      swapper.minimize("foo       bar").should == "foo bar"
    end
  end

  describe "#direction_swap" do
    it "should swap 'rtl' to 'ltr'" do
      swapper.direction_swap('rtl').should == 'ltr'
    end

    it "should swap 'ltr' to 'rtl'" do
      swapper.direction_swap('ltr').should == 'rtl'
    end

    it "should ignore values other than 'ltr' and 'rtl'" do
      [nil, '', 'foo'].each do |val|
        swapper.direction_swap(val).should == val
      end
    end
  end

  describe "#side_swap" do
    it "should swap 'right' to 'left'" do
      swapper.side_swap('right').should == 'left'
    end

    it "should swap 'left' to 'right'" do
      swapper.side_swap('left').should == 'right'
    end

    it "should ignore values other than 'left' and 'right'" do
      [nil, '', 'foo'].each do |val|
        swapper.side_swap(val).should == val
      end
    end
  end

  describe "#quad_swap" do
    it "should swap a valid quad value" do
      swapper.quad_swap("1px 2px 3px 4px").should == "1px 4px 3px 2px"
    end

    it "should skip a pair value" do
      swapper.quad_swap("1px 2px").should == "1px 2px"
    end
  end

  describe "#border_radius_swap" do
    it "should swap a valid quad value" do
      swapper.border_radius_swap("1px 2px 3px 4px").should == "2px 1px 4px 3px"
    end

    it "should skip a triple value" do
      swapper.border_radius_swap("1px 2px 3px").should == "2px 1px 2px 3px"
    end

    it "should skip a pair value" do
      swapper.border_radius_swap("1px 2px").should == "2px 1px"
    end
  end

  describe "#background_position_swap" do

    context "with a single value" do
      it "should ignore a named-vertical" do
        swapper.background_position_swap('top').should == 'top'
      end

      it "should swap a named-horizontal 'left'" do
        swapper.background_position_swap('left').should == 'right'
      end

      it "should swap a named-horizontal 'right'" do
        swapper.background_position_swap('right').should == 'left'
      end

      it "should invert a percentage" do
        swapper.background_position_swap('25%').should == '75%'
      end

      it "should convert a unit value" do
        swapper.background_position_swap('25px').should == 'right 25px center'
      end
    end

    context "with a pair of values" do
      # Note that a pair of keywords can be reordered while a combination of
      # keyword and length or percentage cannot. So ‘center left’ is valid
      # while ‘50% left’ is not.
      # See: http://dev.w3.org/csswg/css3-background/#background-position

      it "should swap named-horizontal and ignore named-vertical" do
        swapper.background_position_swap('right bottom').should == 'left bottom'
      end

      it "should swap named-horizontal and ignore unit-vertical" do
        swapper.background_position_swap('left 100px').should == 'right 100px'
      end

      it "should convert unit-horizontal" do
        swapper.background_position_swap('100px center').should == 'right 100px center'
      end

      it "should swap named-horizontal and ignore percentage-vertical" do
        swapper.background_position_swap('left 0%').should == 'right 0%'
      end

      it "should invert first percentage-horizontal value in a pair" do
        swapper.background_position_swap('25% 100%').should == '75% 100%'
      end
    end

    context "with a triplet of values" do
      it "should swap named-horizontal" do
        swapper.background_position_swap('left 20px center').should == 'right 20px center'
      end
    end

    context "with a quad of values" do
      it "should swap named-horizontal value" do
        swapper.background_position_swap('bottom 10px left 20px').should == 'bottom 10px right 20px'
      end
    end
  end

end
