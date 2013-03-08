module R2
  module CSS
    class Declaration

      class InvalidDeclaration < ArgumentError; end

      extend Forwardable

      PROPERTY_VALUE_REGEXP = /([^:]+):(.+)$/

      PROPERTY_MAP = {
        'margin-left' => 'margin-right',
        'margin-right' => 'margin-left',

        'padding-left' => 'padding-right',
        'padding-right' => 'padding-left',

        'border-left' => 'border-right',
        'border-right' => 'border-left',

        'border-left-width' => 'border-right-width',
        'border-right-width' => 'border-left-width',

        'border-radius-bottomleft' => 'border-radius-bottomright',
        'border-radius-bottomright' => 'border-radius-bottomleft',
        'border-radius-topleft' => 'border-radius-topright',
        'border-radius-topright' => 'border-radius-topleft',

        '-moz-border-radius-bottomright' => '-moz-border-radius-bottomleft',
        '-moz-border-radius-bottomleft' => '-moz-border-radius-bottomright',
        '-moz-border-radius-topright' => '-moz-border-radius-topleft',
        '-moz-border-radius-topleft' => '-moz-border-radius-topright',

        '-webkit-border-top-right-radius' => '-webkit-border-top-left-radius',
        '-webkit-border-top-left-radius' => '-webkit-border-top-right-radius',
        '-webkit-border-bottom-right-radius' => '-webkit-border-bottom-left-radius',
        '-webkit-border-bottom-left-radius' => '-webkit-border-bottom-right-radius',

        'left' => 'right',
        'right' => 'left'
      }

      VALUE_PROCS = {
        'padding'    => lambda {|obj,val| obj.quad_swap(val) },
        'margin'     => lambda {|obj,val| obj.quad_swap(val) },
        'border-radius' => lambda {|obj,val| obj.border_radius_swap(val) },
        '-moz-border-radius' => lambda {|obj,val| obj.border_radius_swap(val) },
        '-webkit-border-radius' => lambda {|obj,val| obj.border_radius_swap(val) },
        'text-align' => lambda {|obj,val| obj.side_swap(val) },
        'float'      => lambda {|obj,val| obj.side_swap(val) },
        'box-shadow' => lambda {|obj,val| obj.quad_swap(val) },
        '-webkit-box-shadow' => lambda {|obj,val| obj.quad_swap(val) },
        '-moz-box-shadow' => lambda {|obj,val| obj.quad_swap(val) },
        'direction'  => lambda {|obj,val| obj.direction_swap(val) },
        'clear' => lambda {|obj,val| obj.side_swap(val) },
        'background-position' => lambda {|obj,val| obj.background_position_swap(val) }
      }

      attr_reader :rule, :css, :property, :value
      def_delegators :@rule, :stylesheet

      def initialize(rule, css)
        @rule    = rule
        self.css = css
      end

      def css=(css)
        raise InvalidDeclaration, "css argument can't be nil" unless css
        @css = css

        if match = css.match(PROPERTY_VALUE_REGEXP)
          @property = match[1]
          @value    = match[2]
        else
          raise InvalidDeclaration, "css argument \"#{css}\" does not appear to be a valid CSS declaration"
        end
      end

      def to_s
        "#{@property}: #{@value};"
      end


      # Flip CSS declaration rule (e.g. <tt>padding-left: 4px</tt>) is translated to the opposing rule (so, <tt>padding-right:4px;</tt> in this example)
      def flip
        @property = PROPERTY_MAP[@property] if PROPERTY_MAP.has_key?(@property)
        @value = VALUE_PROCS[@property].call(self, value) if VALUE_PROCS.has_key?(@property)

        stylesheet.translators.each do |translator|
          @value = translator.transform(@value)
        end
      end

      # Given a value of <tt>rtl</tt> or <tt>ltr</tt> return the opposing value. All other arguments are ignored and returned unmolested.
      def direction_swap(val)
        if val == "rtl"
          "ltr"
        elsif val == "ltr"
          "rtl"
        else
          val
        end
      end

      # Given a value of <tt>right</tt> or <tt>left</tt> return the opposing value. All other arguments are ignored and returned unmolested.
      def side_swap(val)
        if val == "right"
          "left"
        elsif val == "left"
          "right"
        else
          val
        end
      end

      # Given a 4-argument CSS declaration value (like that of <tt>padding</tt> or <tt>margin</tt>) return the opposing
      # value. The opposing value swaps the left and right but not the top or bottom. Any unrecognized argument is returned
      # unmolested (for example, 2-argument values)
      def quad_swap(val)
        # 1px 2px 3px 4px => 1px 4px 3px 2px
        points = val.to_s.split(/\s+/)

        if points && points.length == 4
          [points[0], points[3], points[2], points[1]].join(' ')
        else
          val
        end
      end
      # Border radius uses top-left, top-right, bottom-left, bottom-right, so all values need to be swapped. Additionally,
      # two and three value border-radius declarations need to be swapped as well. Vertical radius, specified with a /,
      # should be left alone.
      def border_radius_swap(val)
        # 1px 2px 3px 4px => 1px 4px 3px 2px
        points = val.to_s.split(/\s+/)

        if points && points.length > 1 && !val.to_s.include?('/')
          case points.length
          when 4
            [points[1], points[0], points[3], points[2]].join(' ')
          when 3
            [points[1], points[0], points[1], points[2]].join(' ')
          when 2
            [points[1], points[0]].join(' ')
          else val
          end
        else
          val
        end
      end

      # Given a background-position such as <tt>left center</tt> or <tt>0% 50%</tt> return the opposing value e.g <tt>right center</tt> or <tt>100% 50%</tt>
      def background_position_swap(val)

        if val =~ /left/
          val.gsub!('left', 'right')
        elsif val =~ /right/
          val.gsub!('right', 'left')
        end

        points = val.strip.split(/\s+/)

        # If first point is a percentage-value
        if match = points[0].match(/(\d+)%/)
          inv = 100 - match[1].to_i # 30% => 70% (100 - x)
          val = ["#{inv}%", points[1]].compact.join(' ')
        end

        # If first point is a unit-value
        if match = points[0].match(/^(\d+[a-z]{2,3})/)
          val = ["right", match[1], points[1] || "center"].compact.join(' ')
        end

        val
      end

    end
  end
end
