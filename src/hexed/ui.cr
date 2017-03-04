require "termbox"

class Hexed::UI
  include Termbox

  property tb : Window
  property data : Bytes
  property offset : Int32
  property bpl : Int32

  def initialize(@data, @aligned = false, @offset = 0)
    @tb = Window.new.tap do |tb|
      tb.clear
      tb.set_input_mode INPUT_ESC | INPUT_MOUSE
      tb.render
    end
    @osw = 4
    @osf = "%0#{@osw}x"
    @bpl = max_bpl(true)
  end

  def run
    update
    loop do
      case (ev = tb.poll).type
      when EVENT_KEY
        break if [KEY_ESC, KEY_CTRL_C, KEY_CTRL_D].includes? ev.key
      when EVENT_MOUSE
      when EVENT_RESIZE
      end
      update
    end
    tb.shutdown
  end

  def update
    draw_data
    tb.render
  end

  def draw_data
    y = 0
    lo = offset
    loop do
      offset_string = @osf % [lo]
      tb.write_string Position.new(0, y), offset_string, COLOR_WHITE, COLOR_BLACK
      n = [bpl, data.size - lo - 1].min
      slice = Slice.new(n, 0_u8)
      data[lo, n].each.with_index do |byte, i|
        hex_string = "%02x" % [byte]
        slice[i] = visual_byte(byte)
        tb.write_string Position.new(@osw + 2 + 3*i, y), hex_string, COLOR_DEFAULT, COLOR_DEFAULT
      end
      string = String.new(slice, "UTF8")
      # puts slice.inspect
      tb.write_string Position.new(@osw + 3 + 3*bpl, y), string, COLOR_BLACK, COLOR_DEFAULT
      lo += bpl
      break if (y += 1) >= h || lo >= data.size
    end
  end

  def w
    tb.width
  end

  def h
    tb.height
  end

  def visual_byte(byte : UInt8) : UInt8
    case byte
    when 32..126
      byte
    else
      46_u8
    end
  end

  def max_bpl(aligned : Bool = false) : Int32
    max = (@tb.width - @osw - 3) / 4
    return max unless aligned
    bpl = 1 
    while bpl <= max / 2
      bpl *= 2
    end
    bpl
  end
end
