module R2::Translators

  # Converts between <tt>rtl</tt> and <tt>ltr</tt>
  # @param [String] val value to swap
  # @return [String] swapped value, or original value if argument is unrecognised
  #
  # @example
  #     direction_swap("ltr") => "rtl"
  def self.direction_swap(val)
    if val == "rtl"
      "ltr"
    elsif val == "ltr"
      "rtl"
    else
      val
    end
  end

  # Converts between <tt>left</tt> and <tt>right</tt>
  # @param [String] val value to swap
  # @return [String] swapped value, or original value if argument is unrecognised
  #
  # @example
  #     side_swap("left") => "right"
  def self.side_swap(val)
    if val =~ /\bright\b/
      val.gsub('right', 'left')
    elsif val =~ /\bleft\b/
      val.gsub('left', 'right')
    else
      val
    end
  end

  # Converts 4-argument edge declaration value (like that of <tt>padding</tt> or <tt>margin</tt>) to its horizontally opposing value
  # @param [String] val value to swap
  # @return [String] horizontally swapped value, or original value if argument is unrecognised
  #
  # @example
  #     edge_swap("1px 2px 3px 4px") => "1px 4px 3px 2px"
  def self.edge_swap(val)
    edges = val.to_s.split(/\s+/)
    if edges.length == 4
      [edges[0], edges[3], edges[2], edges[1]].join(' ')
    else
      val
    end
  end

  # Converts 2, 3 or 4-argument corner declaration value (like that of <tt>border-radius</tt> ) to its horizontally opposing value.
  # Values with vertical radius, specified with a <tt>/</tt> are left alone.
  # @param [String] val value to swap
  # @return [String] horizontally swapped value, or original value if argument is unrecognised
  #
  # @example 2-argument conversion
  #     corner_swap("1px 2px") => "2px 1px"
  #
  # @example 3-argument conversion
  #     corner_swap("1px 2px 3px") => "2px 1px 2px 3px"
  #
  # @example 4-argument conversion
  #     corner_swap("1px 2px 3px 4px") => "2px 1px 4px 3px"
  def self.corner_swap(val)
    corners = val.to_s.split(/\s+/)
    if corners.length > 1 && !val.to_s.include?('/')
      case corners.length
      when 4
        [corners[1], corners[0], corners[3], corners[2]].join(' ')
      when 3
        [corners[1], corners[0], corners[1], corners[2]].join(' ')
      when 2
        [corners[1], corners[0]].join(' ')
      else val
      end
    else
      val
    end
  end

  # Converts a 1 or 2-argument position declaration value (like that of <tt>background-position</tt> ) to its horizontally opposing value.
  # @param [String] val value to swap
  # @return [String] horizontally swapped value, or original value if argument is unrecognised
  #
  # @example named values
  #     position_swap("left center") => "right center"
  #
  # @example percentage values
  #     position_swap("0% 50%") => "100% 50%"
  def self.position_swap(val)

    if val =~ /left/
      val.gsub!('left', 'right')
    elsif val =~ /right/
      val.gsub!('right', 'left')
    end

    x, y = val.strip.split(/\s+/)

    if match = x.match(/(\d+)%/)
      # x is a percentage-value
      inv = 100 - match[1].to_i # 30% => 70% (100 - x)
      val = ["#{inv}%", y].compact.join(' ')

    elsif match = x.match(/^(\d+[a-z]{2,3})/)
      # x is a unit-value
      val = ["right", match[1], y || "center"].compact.join(' ')
    end

    val
  end

end
