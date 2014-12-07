require 'rails_helper'

RSpec.describe "districts/show", :type => :view do
  before(:each) do
    @district = assign(:district, District.create!(
      :en_name => "En Name",
      :ar_name => "Ar Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/En Name/)
    expect(rendered).to match(/Ar Name/)
  end
end
