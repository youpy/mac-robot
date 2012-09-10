require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# how to test???
describe Mac::Robot do
  subject do
    Mac::Robot.new
  end

  describe 'mouse event' do
    it 'should simulate mouse event' do
      subject.mouse_move(20, 0)
      subject.mouse_press(:left)
      subject.mouse_move(20, 250)
      subject.mouse_release(:left)
    end
  end

  describe 'scroll wheel event' do
    it 'should simulate scroll wheel event' do
      subject.scroll_wheel_line(:up => 10)
      subject.scroll_wheel(:down => 10)
      subject.scroll_wheel_pixel(:right => 10, :down => 20)
      subject.scroll_wheel_pixel(:up => 20, :left => 10)
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
      color.red.should be_a_kind_of(Float)
      color.green.should be_a_kind_of(Float)
      color.blue.should be_a_kind_of(Float)
      color.alpha.should be_a_kind_of(Float)
    end

    it 'should raise if given coordinate is out of resolution' do
      [9999, -1].each do |p|
        lambda {
          subject.get_pixel_color(p, 0)
        }.should raise_error(Mac::Robot::OutOfResolution)

        lambda {
          subject.get_pixel_color(0, p)
        }.should raise_error(Mac::Robot::OutOfResolution)
      end
    end
  end
end
