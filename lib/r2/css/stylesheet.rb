require 'r2/css/rule'

module R2
  module CSS
    class Stylesheet

      class InvalidStylesheet < ArgumentError; end

      RULE_REGEXP = /([^\{]+\{[^\}]+\})+?/

      attr_reader :translations, :rules

      # Instantiate a new Stylesheet instance from the supplied css
      # @param [String] css the source css
      # @return [R2::CSS::Stylesheet] a Stylesheet instance
      def initialize(css)
        @rules   = []
        self.css = css
      end

      # Parse css into Array of Rule instances
      # @param [String] css the source css
      def css=(css)
        raise InvalidStylesheet, "css argument can't be nil" unless css
        @css = css
        minimize(@css).gsub(RULE_REGEXP) do |rule|
          @rules << R2::CSS::Rule.new(self, rule)
        end
        raise InvalidStylesheet, "no CSS rules found" if @rules.empty?
      end

      # css for this Stylesheet
      # @return [String] css
      def css
        rules.map(&:to_s).join("\n") + "\n"
      end
      alias_method :to_s, :css

      # Minimize the provided CSS by removing comments, and extra spaces
      # @param [String] css the source css
      def minimize(css)
        return '' unless css

        css.gsub(/\/\*[\s\S]+?\*\//, '').   # comments
           gsub(/[\n\r]/, '').              # line breaks and carriage returns
           gsub(/\s*([:;,\{\}])\s*/, '\1'). # space between selectors, declarations, properties and values
           gsub(/\s+/, ' ')                 # replace multiple spaces with single spaces
      end
      private :minimize

      # Translate the stylesheet
      # @param [Array<R2::Translation>] translations an Array of translations to apply to the stylesheet
      # @return [R2::CSS::Stylesheet] the translated Stylesheet instance
      def translate(translations)
        @rules.map do |rule|
          rule.translate(translations)
        end
        self
      end

    end
  end
end
