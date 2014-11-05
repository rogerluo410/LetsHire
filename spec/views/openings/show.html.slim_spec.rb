require 'spec_helper'

describe "openings/show" do
  before(:each) do
    @opening2 = assign(:opening, stub_model(Opening,
      :title => "Sales Manager",
      :country => "CN",
      :province => '10',
      :city => 'Shanghai'
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Sales Manager/)
    rendered.should match(/China/)
  end
end
