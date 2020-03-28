module ANSIColors
  Colors = {
    none: 0,
    black: 30,
    red: 31,
    green: 32,
    yellow: 33,
    blue: 34,
    magenta: 35,
    cyan: 36,
    white: 37,
  }.freeze

  def self.colorize input, color
    return input unless color 

    color = color.to_sym

    if color == :none
      return input
    end

    color_code = if color.start_with? 'bright'
                   code = Colors[color.to_s.split('_').last.to_sym]
                   "#{code};1"
                 else
                   Colors[color.to_sym]
                 end

    "\e[#{color_code}m#{input}\e[0m"
  end

  def self.colors
    @colors ||= Colors.keys.concat(Colors.keys.map { |c| "bright_#{c}".to_sym })
  end
end
