module R2
  module CSS
    class Declaration

      class InvalidDeclaration < ArgumentError; end

      extend Forwardable

      PROPERTY_VALUE_REGEXP = /([^:]+):(.+)$/

      attr_reader :rule, :css
      attr_accessor :property, :value
      def_delegators :@rule, :stylesheet

      # Create a new Declaration instance
      # @param [R2::CSS:Rule] rule the parent Rule for this Declaration
      # @param [String] css the css for this Declaration
      def initialize(rule, css)
        @rule    = rule
        self.css = css
      end

      # Parse css into property and value
      # @param [String] css the source css
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

      # css for this Declaration
      # @return [String] css
      def css
        "#{@property}: #{@value};"
      end
      alias_method :to_s, :css

    end
  end
end
