require 'rails_helper'

RSpec.describe "vendors/edit", type: :view do
  let(:vendor) {
    Vendor.create!(
      name: "MyString",
      email: "test@test.com",
      description: "MyText",
      api_endpoint: "MyString",
      api_key: "MyString"
    )
  }

  before(:each) do
    assign(:vendor, vendor)
  end

  it "renders the edit vendor form" do
    pending "fix"
    render

    assert_select "form[action=?][method=?]", vendor_path(vendor), "post" do

      assert_select "input[name=?]", "vendor[name]"

      assert_select "input[name=?]", "vendor[email]"

      assert_select "textarea[name=?]", "vendor[description]"

      assert_select "input[name=?]", "vendor[api_endpoint]"

      assert_select "input[name=?]", "vendor[api_key]"
    end
  end
end
