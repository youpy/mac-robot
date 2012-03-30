require 'event_dispatcher'
require 'util'

module Mac
  class Robot
    attr_reader :x, :y

    BUTTONS = {
      :left => 0,
      :right => 1,
      :center => 2
    }

    def initialize
      @x = 0
      @y = 0
      @state = :mouse_up
      @dispatcher = EventDispatcher.new
    end

    def mouse_press(button = :left)
      mouse_event(button, :mouse_down)
      @state = :mouse_down
    end

    def mouse_release(button = :left)
      mouse_event(button, :mouse_up)
      @state = :mouse_up
    end

    def mouse_move(x, y)
      @x = x
      @y = y

      mouse_event(:left, :mouse_move)
    end

    def key_press(keycode)
      keyboard_event(keycode, 1)
    end

    def key_release(keycode)
      keyboard_event(keycode, 0)
    end

    def get_pixel_color(x, y)
      color = Util.get_pixel_color(x, y)
      Struct.new(:red, :green, :blue, :alpha).new(*color)
    end

    private

    def mouse_event(button, type)
      @dispatcher.dispatchMouseEvent(@x, @y, BUTTONS[button], type)
    end

    def keyboard_event(keycode, keydown)
      @dispatcher.dispatchKeyboardEvent(keycode, keydown)
    end
  end
end
