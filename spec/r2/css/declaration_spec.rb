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

  describe "#flip" do

    describe "with instance with flippable property" do
      let(:css) { "padding-right:4px" }
      subject(:declaration) { R2::CSS::Declaration.new(rule, css) }

      it "should flip property" do
        declaration.flip
        declaration.to_s.should == 'padding-left: 4px;'
      end

    end

    describe "with instance with flippable value" do
      let(:css) { "direction:ltr" }
      subject(:declaration) { R2::CSS::Declaration.new(rule, css) }

      it "should flip value" do
        declaration.flip
        declaration.to_s.should == 'direction: rtl;'
      end

    end

    describe "with instance with unflippable property or value" do
      let(:css) { "font-weight:bold" }
      subject(:declaration) { R2::CSS::Declaration.new(rule, css) }

      it "should not alter declaration" do
        declaration.flip
        declaration.to_s.should == "font-weight: bold;"
      end

    end

  end

  describe "instance" do

    let(:css) { "direction:ltr" }
    subject(:declaration) { R2::CSS::Declaration.new(rule, css) }

    its(:rule) { should == rule }
    its(:css)  { should == css }

    its(:property) { should == "direction" }
    its(:value)    { should == "ltr" }


    its(:to_s) { should == "direction: ltr;" }

    describe "#direction_swap" do
      it "should swap 'rtl' to 'ltr'" do
        declaration.direction_swap('rtl').should == 'ltr'
      end

      it "should swap 'ltr' to 'rtl'" do
        declaration.direction_swap('ltr').should == 'rtl'
      end

      it "should ignore values other than 'ltr' and 'rtl'" do
        [nil, '', 'foo'].each do |val|
          declaration.direction_swap(val).should == val
        end
      end
    end

    describe "#side_swap" do
      it "should swap 'right' to 'left'" do
        declaration.side_swap('right').should == 'left'
      end

      it "should swap 'left' to 'right'" do
        declaration.side_swap('left').should == 'right'
      end

      it "should ignore values other than 'left' and 'right'" do
        [nil, '', 'foo'].each do |val|
          declaration.side_swap(val).should == val
        end
      end
    end

    describe "#quad_swap" do
      it "should swap a valid quad value" do
        declaration.quad_swap("1px 2px 3px 4px").should == "1px 4px 3px 2px"
      end

      it "should skip a pair value" do
        declaration.quad_swap("1px 2px").should == "1px 2px"
      end
    end

    describe "#border_radius_swap" do
      it "should swap a valid quad value" do
        declaration.border_radius_swap("1px 2px 3px 4px").should == "2px 1px 4px 3px"
      end

      it "should skip a triple value" do
        declaration.border_radius_swap("1px 2px 3px").should == "2px 1px 2px 3px"
      end

      it "should skip a pair value" do
        declaration.border_radius_swap("1px 2px").should == "2px 1px"
      end
    end

    describe "#background_position_swap" do

      context "with a single value" do
        it "should ignore a named-vertical" do
          declaration.background_position_swap('top').should == 'top'
        end

        it "should swap a named-horizontal 'left'" do
          declaration.background_position_swap('left').should == 'right'
        end

        it "should swap a named-horizontal 'right'" do
          declaration.background_position_swap('right').should == 'left'
        end

        it "should invert a percentage" do
          declaration.background_position_swap('25%').should == '75%'
        end

        it "should convert a unit value" do
          declaration.background_position_swap('25px').should == 'right 25px center'
        end
      end

      context "with a pair of values" do
        # Note that a pair of keywords can be reordered while a combination of
        # keyword and length or percentage cannot. So ‘center left’ is valid
        # while ‘50% left’ is not.
        # See: http://dev.w3.org/csswg/css3-background/#background-position

        it "should swap named-horizontal and ignore named-vertical" do
          declaration.background_position_swap('right bottom').should == 'left bottom'
        end

        it "should swap named-horizontal and ignore unit-vertical" do
          declaration.background_position_swap('left 100px').should == 'right 100px'
        end

        it "should convert unit-horizontal" do
          declaration.background_position_swap('100px center').should == 'right 100px center'
        end

        it "should swap named-horizontal and ignore percentage-vertical" do
          declaration.background_position_swap('left 0%').should == 'right 0%'
        end

        it "should invert first percentage-horizontal value in a pair" do
          declaration.background_position_swap('25% 100%').should == '75% 100%'
        end
      end

      context "with a triplet of values" do
        it "should swap named-horizontal" do
          declaration.background_position_swap('left 20px center').should == 'right 20px center'
        end
      end

      context "with a quad of values" do
        it "should swap named-horizontal value" do
          declaration.background_position_swap('bottom 10px left 20px').should == 'bottom 10px right 20px'
        end
      end
    end

  end

end
