require 'spec_helper'

describe XTeamSchedule::Colour do
  
  describe 'defaults' do
    it 'uses 1 for alpha' do
      XTeamSchedule::Colour.new.alpha.should == 1
    end
    
    it 'uses 0.5 for red' do
      XTeamSchedule::Colour.new.red.should == 0.5
    end
    
    it 'uses 0.5 for green' do
      XTeamSchedule::Colour.new.green.should == 0.5
    end
    
    it 'uses 0.5 for blue' do
      XTeamSchedule::Colour.new.blue.should == 0.5
    end
  end
  
  describe 'validations' do
    before do
      @colour = Factory(:colour)
    end
    
    it 'requires an alpha' do
      @colour.alpha = nil
      @colour.should_not be_valid
    end
    
    it 'requires a red' do
      @colour.red = nil
      @colour.should_not be_valid
    end
    
    it 'requires a green' do
      @colour.green = nil
      @colour.should_not be_valid
    end
    
    it 'requires a blue' do
      @colour.blue = nil
      @colour.should_not be_valid
    end
  end
  
end
