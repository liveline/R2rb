module R2

  # A Translator is used to modify an arbitrary CSS value.
  # When a Translator matcher matches a CSS value the match(es) are passed to the handler for modification
  #
  # @example Convert all instances of `red` to `green`
  #     R2::Translator.new(/(red)/, Proc.new {|value, match| value.gsub(match, 'green')} )
  class Translator

    # Creates a new Translator instance
    #
    # @param [String, Regexp #match] an object that responds to #match e.g. a String or a Regexp
    # @param [Proc, #call] an object that responds to #call with parameters e.g. a Proc
    def initialize(matcher, handler)
      raise ArgumentError, "matcher must respond to :match" unless matcher.respond_to?(:match)
      raise ArgumentError, "handler must respond to :call"  unless handler.respond_to?(:call)
      @matcher = matcher
      @handler = handler
    end

    attr_reader :matcher, :handler

    # Transforms string using handler if string matches matcher
    #
    # @param [String] the source string to transform
    # @return [String] the transformed string
    def transform(val)
      if match = val.match(matcher)
        old_val = match[0]
        new_val = handler.call(*match)
        val.gsub!(old_val, new_val)
      end
      val
    end

  end
end
