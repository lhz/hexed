require "termbox"

require "./hexed/*"

class Hexed::UI
  include Termbox

  property tb : Window

  def initialize
    @tb = Window.new.tap do |tb|
      tb.clear
      tb.set_input_mode INPUT_ESC | INPUT_MOUSE
      tb.write_string Position.new(16, 4), "Hello folks!"
      tb.render
    end
  end

  def run
    loop do
      case (ev = tb.poll).type
      when EVENT_KEY
        break if [KEY_ESC, KEY_CTRL_C, KEY_CTRL_D].includes? ev.key
      when EVENT_MOUSE
      when EVENT_RESIZE
      end
      tb.render
    end
    tb.shutdown
  end

  def w
    tb.width
  end

  def h
    tb.height
  end
end

ui = Hexed::UI.new
ui.run
