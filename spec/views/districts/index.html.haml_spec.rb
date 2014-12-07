require 'rails_helper'

RSpec.describe "districts/index", :type => :view do
  before(:each) do
    assign(:districts, [
      District.create!(
        :en_name => "En Name",
        :ar_name => "Ar Name"
      ),
      District.create!(
        :en_name => "En Name",
        :ar_name => "Ar Name"
      )
    ])
  end

  it "renders a list of districts" do
    render
    assert_select "tr>td", :text => "En Name".to_s, :count => 2
    assert_select "tr>td", :text => "Ar Name".to_s, :count => 2
  end
end
