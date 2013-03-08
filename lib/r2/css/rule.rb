require 'r2/css/declaration'

module R2
  module CSS
    class Rule

      class InvalidRule < ArgumentError; end

      SELECTOR_DECLARATION_REGEXP = /([^\{]+)\{([^\}]+)/

      attr_reader :stylesheet, :css, :selector, :declarations

      def initialize(stylesheet, css)
        @stylesheet   = stylesheet
        @declarations = []
        self.css = css
      end

      def css=(css)
        raise InvalidRule, "css argument can't be nil" unless css
        @css = css

        if match = css.match(SELECTOR_DECLARATION_REGEXP)
          @selector    = match[1]
          declarations = match[2]

          declarations.split(/;(?!base64)/).each do |declaration|
            @declarations << R2::CSS::Declaration.new(self, declaration)
          end
        else
          raise InvalidRule, "css argument \"#{css}\" does not appear to be a valid CSS rule"
        end
      end

      def flip
        @declarations.map(&:flip)
      end

      def to_s
        "#{@selector} {\n" +
          declarations.map{ |declaration| "  #{declaration}" }.join("\n") +
        "\n}"
      end

    end
  end
end
