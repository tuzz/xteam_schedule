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
    
    it "uses true for 'display_resources_pictures'" do
      XTeamSchedule::Interface.new.display_resources_pictures.should be_true
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
  
  describe 'aliases' do
    before do
      @interface = Factory(:interface)
    end
    
    it "aliases 'display_assignment_names' to 'display_assignments_name'" do
      @interface.display_assignments_name = false
      @interface.display_assignment_names.should be_false
    end
    
    it "aliases 'display_assignment_names=' to 'display_assignments_name='" do
      @interface.display_assignment_names = false
      @interface.display_assignments_name.should be_false
    end
    
    it "aliases 'display_resource_names' to 'display_resources_name'" do
      @interface.display_resources_name = true
      @interface.display_resource_names.should be_true
    end
    
    it "aliases 'display_resource_names=' to 'display_resources_name='" do
      @interface.display_resources_name = true
      @interface.display_resource_names.should be_true
    end
    
    it "aliases 'display_resource_pictures' to 'display_resources_pictures'" do
      @interface.display_resources_pictures = false
      @interface.display_resource_pictures.should be_false
    end
    
    it "aliases 'display_resource_pictures=' to 'display_resources_pictures='" do
      @interface.display_resources_pictures = false
      @interface.display_resource_pictures.should be_false
    end
    
    it "aliases 'display_total_working_hours' to 'display_total_of_working_hours'" do
      @interface.display_total_of_working_hours = true
      @interface.display_total_working_hours.should be_true
    end
    
    it "aliases 'display_total_working_hours=' to 'display_total_of_working_hours='" do
      @interface.display_total_working_hours = true
      @interface.display_total_of_working_hours.should be_true
    end
    
    it "aliases 'display_assignment_notes' to 'display_assignments_notes'" do
      @interface.display_assignments_notes = true
      @interface.display_assignment_notes.should be_true
    end
    
    it "aliases 'display_assignment_notes=' to 'display_assignments_notes='" do
      @interface.display_assignment_notes = true
      @interface.display_assignments_notes.should be_true
    end
  end
  
end
