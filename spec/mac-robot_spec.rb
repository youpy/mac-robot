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

  describe 'keyboard event' do
    it 'should simulate keyboard event' do
      [0x04, 0x0e, 0x25, 0x25, 0x1f].each do |keycode|
        subject.key_press(keycode)
        subject.key_release(keycode)
      end
    end
  end
end
