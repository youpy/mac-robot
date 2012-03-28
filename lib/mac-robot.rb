require 'event_dispatcher'

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

    private

    def mouse_event(button, type)
      dispatcher = EventDispatcher.new
      dispatcher.dispatchMouseEvent(@x, @y, BUTTONS[button], type)
    end
  end
end
