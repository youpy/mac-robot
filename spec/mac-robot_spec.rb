require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# how to test???
describe Mac::Robot do
  subject { Mac::Robot.new }

  describe 'mouse event' do
    it 'should simulate mouse event' do
      subject.mouse_move(20, 0)
      sleep 0.2
      subject.mouse_press(:left)
      sleep 0.2
      subject.mouse_move(20, 200)
      sleep 0.2
      subject.mouse_release(:left)
    end
  end

  describe 'scroll wheel event' do
    it 'should simulate scroll wheel event' do
      subject.scroll_wheel_line(y: 10) # down 10 lines
      subject.scroll_wheel(y: -10) # up 10 lines
      subject.scroll_wheel_pixel(x: 10, y: -20, z: 5)
      subject.scroll_wheel_pixel(y: 20, x: -10, z: -5)
    end
  end

  describe 'keyboard event' do
    it 'should simulate keyboard event' do
      [0x04, 0x0e, 0x25, 0x25, 0x1f].each do |keycode|
        subject.key_press(keycode)
        subject.key_release(keycode)
      end
    end
  end

  describe 'color' do
    it 'should get color from given coordinate' do
      color = subject.get_pixel_color(0, 0)
      expect(color.red).to be_a_kind_of(Float)
      expect(color.green).to be_a_kind_of(Float)
      expect(color.blue).to be_a_kind_of(Float)
      expect(color.alpha).to be_a_kind_of(Float)
    end

    it 'should raise if given coordinate is out of resolution' do
      [9999, -1].each do |p|
        expect { subject.get_pixel_color(p, 0) }.to raise_error(
          Mac::Robot::OutOfResolution
        )

        expect { subject.get_pixel_color(0, p) }.to raise_error(
          Mac::Robot::OutOfResolution
        )
      end
    end

    it 'should get color from rightmost pixel' do
      display_pixel_size = subject.display_pixel_size

      color = subject.get_pixel_color(display_pixel_size.width, 0)
      expect(color.red).to be_a_kind_of(Float)
      expect(color.green).to be_a_kind_of(Float)
      expect(color.blue).to be_a_kind_of(Float)
      expect(color.alpha).to be_a_kind_of(Float)
    end
  end

  describe 'current mouse location' do
    it 'should have current mouse location' do
      subject.mouse_move(20, 0)
      expect(subject.mouse_current_location.x).to eql(20)
      expect(subject.mouse_current_location.y).to eql(0)
    end
  end
end
