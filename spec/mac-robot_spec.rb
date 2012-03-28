require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Mac::Robot do
  subject do
    Mac::Robot.new
  end

  describe 'mouse event' do
    # how to test???
    it 'should simulate mouse event' do
      subject.mouse_press(:left)
      subject.mouse_move(250, 250)
      subject.mouse_release(:left)
    end
  end
end
