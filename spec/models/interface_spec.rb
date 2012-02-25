require 'spec_helper'

describe XTeamSchedule::Interface do
  
  describe 'defaults' do    
    it "uses true for 'display_assignments_name'" do
      XTeamSchedule::Interface.new.display_assignments_name.should be_true
    end
    
    it "uses false for 'display_resources_name'" do
      XTeamSchedule::Interface.new.display_resources_name.should be_false
    end
    
    it "uses false for 'display_working_hours'" do
      XTeamSchedule::Interface.new.display_working_hours.should be_false
    end
    
    it "uses true for 'display_resources_picture'" do
      XTeamSchedule::Interface.new.display_resources_picture.should be_true
    end
    
    it "uses false for 'display_total_of_working_hours'" do
      XTeamSchedule::Interface.new.display_total_of_working_hours.should be_false
    end
    
    it "uses true for 'display_assignments_notes'" do
      XTeamSchedule::Interface.new.display_assignments_notes.should be_true
    end
    
    it "uses true for 'display_absences'" do
      XTeamSchedule::Interface.new.display_absences.should be_true
    end
  end
  
  describe 'associations' do
    before do
      @interface = Factory(:interface)
    end
    
    it 'belongs to a schedule' do
      @interface.schedule.should be_nil
      schedule = Factory(:schedule, :interface => @interface)
      @interface.schedule.should == schedule
    end
  end
  
end
