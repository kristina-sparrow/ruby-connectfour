# frozen_string_literal: true

module Color
  def color_map(color)
    {
      red: 31, red_bg: 41,
      green: 32, green_bg: 42,
      yellow: 33, yellow_bg: 43,
      blue: 34, blue_bg: 44,
      magenta: 35, magenta_bg: 45,
      cyan: 36, cyan_bg: 46
    }[color]
  end

  def color_text(text, color)
    "\e[#{color_map(color)}m#{text}\e[0m"
  end
end
