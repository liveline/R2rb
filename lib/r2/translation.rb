require 'r2/css/declaration'

module R2

  # A Translation is used to modify an arbitrary CSS declaration.
  #
  class Translation

    # Creates a new Translation instance
    #
    # @param [Hash{Symbol=>Regexp}] matchers a hash containing a <tt>:position</tt> and/or <tt>:value</tt> regex
    # @param [Proc, #call] translator an object that responds to #call with parameters e.g. a Proc
    #
    # @example Translation to convert `color` properties to `colour`
    #     R2::Translation.new(:property => /color/) do
    #       value.gsub!('color', 'colour')
    #     end
    #
    # @example Translation to convert `red` values to `green`
    #     R2::Translation.new(:value => /red/) do
    #       value.gsub!('red', 'green')
    #     end
    def initialize(matchers, &translator)
      raise ArgumentError, "matcher keys must be :property or :value" unless matchers.all? { |k, v| [:property, :value].include?(k) }
      raise ArgumentError, "matchers must respond to :match" unless matchers.all? { |k, v| v.respond_to?(:match) }
      raise ArgumentError, "no translator block given" unless block_given?
      @matchers   = matchers
      @translator = translator
    end

    attr_reader :matchers, :translator

    # Transforms string using translator if string matches matchers
    #
    # @param [R2::CSS::Declaration] declaration the source Declaration to transform
    # @return [R2::CSS::Declaration] the transformed Declaration
    def translate(declaration)
      property_matches = matchers[:property] && declaration.property.match(matchers[:property])
      value_matches    = matchers[:value] && declaration.value.match(matchers[:value])
      if property_matches || value_matches
        declaration.instance_eval(&translator)
      end
      declaration
    end

  end
end
