require 'event_dispatcher'
require 'util'

module Mac
  class Robot
    class Error < StandardError; end
    class OutOfResolution < Error; end

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

    def scroll_wheel_line(args = {})
      scroll_wheel_event(:line, *scroll_count_extract(args))
    end
    alias scroll_wheel scroll_wheel_line

    def scroll_wheel_pixel(args = {})
      scroll_wheel_event(:pixel, *scroll_count_extract(args))
    end

    def get_pixel_color(x, y)
      raise OutOfResolution if x < 0 || y < 0
      raise OutOfResolution if display_pixel_size.width < x || display_pixel_size.height < y

      color = Util.get_pixel_color(x, y)
      Struct.new(:red, :green, :blue, :alpha).new(*color)
    end

    def display_pixel_size
      @screen ||= Struct.new(:width, :height).new(*Util.get_display_pixel_size)
    end

    private

    def mouse_event(button, type)
      @dispatcher.dispatchMouseEvent(@x, @y, BUTTONS[button], type)
    end

    def scroll_wheel_event(unit, scroll_y, scroll_x = 0, scroll_z = 0)
      wheel_count = 3
      @dispatcher.dispatchScrollWheelEvent(unit, wheel_count, scroll_y, scroll_x, scroll_z)
    end

    def scroll_count_extract(args = {})
      # default values
      scroll_y = 0
      scroll_x = 0
      scroll_z = 0

      args.each do |key, value|
        case key
        when :up
          scroll_y += value
        when :down
          scroll_y -= value
        when :left
          scroll_x += value
        when :right
          scroll_x -= value
        when :front, :back
          warn "direction `#{key.to_s}' is not implemented."
          # TODO: not implemented. positive value means front or back?
        end
      end

      return [scroll_y, scroll_x, scroll_z]
    end

    def keyboard_event(keycode, keydown)
      @dispatcher.dispatchKeyboardEvent(keycode, keydown)
    end
  end
end
