require 'rails_helper'

RSpec.describe "districts/new", :type => :view do
  before(:each) do
    assign(:district, District.new(
      :en_name => "MyString",
      :ar_name => "MyString"
    ))
  end

  it "renders new district form" do
    render

    assert_select "form[action=?][method=?]", districts_path, "post" do

      assert_select "input#district_en_name[name=?]", "district[en_name]"

      assert_select "input#district_ar_name[name=?]", "district[ar_name]"
    end
  end
end
