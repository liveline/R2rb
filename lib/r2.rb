require 'r2/css/stylesheet'
require 'r2/translator'

# Change the directionality of a block of CSS code from right-to-left to left-to-right. This includes not only
# altering the <tt>direction</tt> attribute but also altering the 4-argument version of things like <tt>padding</tt>
# to correctly reflect the change. CSS is also minified, in part to make the processing easier.
#
# Author::    Matt Sanford  (mailto:matt@twitter.com)
# Copyright:: Copyright (c) 2011 Twitter, Inc.
# License::   Licensed under the Apache License, Version 2.0
module R2

  # Short cut method for providing a one-time CSS change
  def self.r2(*args)
    CSS::Stylesheet.new(*args).flip
  end

end
