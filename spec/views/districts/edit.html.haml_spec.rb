require 'rails_helper'

RSpec.describe "districts/edit", :type => :view do
  before(:each) do
    @district = assign(:district, District.create!(
      :en_name => "MyString",
      :ar_name => "MyString"
    ))
  end

  it "renders the edit district form" do
    render

    assert_select "form[action=?][method=?]", district_path(@district), "post" do

      assert_select "input#district_en_name[name=?]", "district[en_name]"

      assert_select "input#district_ar_name[name=?]", "district[ar_name]"
    end
  end
end
