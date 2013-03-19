require 'r2/css/declaration'

module R2
  module CSS
    class Rule

      class InvalidRule < ArgumentError; end

      SELECTOR_DECLARATION_REGEXP = /([^\{]+)\{([^\}]+)/

      attr_reader :stylesheet, :selector, :declarations

      # Create a new Rule instance
      # @param [R2::CSS:Stylesheet] stylesheet the parent Stylesheet for this Rule
      # @param [String] css the css for this Rule
      def initialize(stylesheet, css)
        @stylesheet   = stylesheet
        @declarations = []
        self.css = css
      end

      # Parse css into Array of Declaration instances
      # @param [String] css the source css
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

      # css for this Rule
      # @return [String] css
      def css
        "#{@selector} {\n" +
          declarations.map{ |declaration| "  #{declaration}" }.join("\n") +
        "\n}"
      end
      alias_method :to_s, :css

      # Translate rule declarations
      # @param [Array<R2::Translation>] translations Array of Translations to apply to Declarations
      def translate(translations)
        return unless translations && !translations.empty?
        @declarations.map do |declaration|
          translations.each do |translation|
            declaration = translation.translate(declaration)
          end
          declaration
        end
      end

    end
  end
end
