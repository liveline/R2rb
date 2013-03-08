require 'r2/css/rule'

module R2
  module CSS
    class Stylesheet

      class InvalidStylesheet < ArgumentError; end

      RULE_REGEXP = /([^\{]+\{[^\}]+\})+?/

      attr_reader :translators, :css, :rules

      def initialize(css, options = {})
        @translators = [*options[:translators]].compact
        @rules   = []
        self.css = css
      end

      def css=(css)
        raise InvalidStylesheet, "css argument can't be nil" unless css
        @css = css
        minimize(@css).gsub(RULE_REGEXP) do |rule|
          @rules << R2::CSS::Rule.new(self, rule)
        end
        raise InvalidStylesheet, "no CSS rules found" if @rules.empty?
      end

      # Minimize the provided CSS by removing comments, and extra specs
      def minimize(css)
        return '' unless css

        css.gsub(/\/\*[\s\S]+?\*\//, '').   # comments
           gsub(/[\n\r]/, '').              # line breaks and carriage returns
           gsub(/\s*([:;,\{\}])\s*/, '\1'). # space between selectors, declarations, properties and values
           gsub(/\s+/, ' ')                 # replace multiple spaces with single spaces
      end
      private :minimize

      def flip
        @rules.map(&:flip)
        to_s
      end

      def to_s
        rules.map(&:to_s).join("\n") + "\n"
      end

    end
  end
end
