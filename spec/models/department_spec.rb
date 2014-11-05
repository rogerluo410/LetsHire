require 'spec_helper'

describe Department do
  it 'has a valid factory' do
    FactoryGirl.create(:department).should be_valid
  end

  it 'requires name to be present & unique' do
    FactoryGirl.build(:department, :name => nil).should_not be_valid
    department = FactoryGirl.create(:department)
    FactoryGirl.build(:department, :name => department.name).should_not be_valid
  end



end
