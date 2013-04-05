require 'r2/css/stylesheet'
require 'r2/translations_builder'
require 'r2/translators'

# Convert a block of CSS using arbitrary translations
#
# Author::    Matt Sanford  (mailto:matt@twitter.com)
# Copyright:: Copyright (c) 2011 Twitter, Inc.
# License::   Licensed under the Apache License, Version 2.0
module R2

  RTL_TRANSLATIONS = Proc.new {

    # Property left|right swap
    match :property => /\b(left|right)\b/ do
      property.gsub!(property, Translators.side_swap(property))
    end

    # Direction swap
    match :property => /^direction$/ do
      value.gsub!(value, Translators.direction_swap(value))
    end

    # Side swap
    match :property => /^(text-align|float|clear)$/ do
      value.gsub!(value, Translators.side_swap(value))
    end

    # Edge swap
    match :property => /(margin|padding)$/ do
      value.gsub!(value, Translators.edge_swap(value))
    end

    # Offset swap
    match :property => /^box-shadow$/ do
      value.gsub!(value, Translators.offset_swap(value))
    end

    # Corner swap
    match :property => /border-radius$/ do
      value.gsub!(value, Translators.corner_swap(value))
    end

    # Position swap
    match :property => /^background-position$/ do
      value.gsub!(value, Translators.position_swap(value))
    end
  }

  # Convert css using supplied translations
  def self.translate(css, &block)
    translations = TranslationsBuilder.compile(&block) if block_given?
    CSS::Stylesheet.new(css).translate(translations)
  end

  # Convert css from LTR to RTL and apply optional translations
  def self.r2(css, &block)
    translations  = TranslationsBuilder.compile(&RTL_TRANSLATIONS)
    translations += TranslationsBuilder.compile(&block) if block_given?
    CSS::Stylesheet.new(css).translate(translations)
  end

end
