require 'docile'
require 'r2/translation'

module R2

  class TranslationsBuilder

    attr_reader :translations

    # Compile translations DSL into Array of Translation instances
    # @param [Proc] block block of <tt>match</tt> directives
    # @return [Array<R2::Translation>] Array of Translation instances
    #
    # @example
    #     TranslationsBuilder.compile do
    #       match :value => /^red$/ do
    #         value.gsub!('red', 'green')
    #       end
    #     end
    def self.compile(&block)
      ::Docile.dsl_eval(TranslationsBuilder.new, &block).translations if block_given?
    end

    def initialize
      @translations = []
    end
    private :initialize

    # Define a Translation instance
    # @param [Hash{Symbol=>Regexp}] matchers a hash containing a <tt>:position</tt> and/or <tt>:value</tt> regex
    # @param [Proc, #call] translator an object that responds to #call with parameters e.g. a Proc
    #
    # @example Define a Translation which converts 'red' values to 'green'
    #     match :value => /^red$/ do
    #       value.gsub!('red', 'green')
    #     end
    def match(matchers, &block)
      @translations << R2::Translation.new(matchers, &block)
    end

  end

end
