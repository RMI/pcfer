require 'rails_helper'

RSpec.describe "vendors/new", type: :view do
  before(:each) do
    assign(:vendor, Vendor.new(
      name: "MyString",
      email: "MyString",
      description: "MyText",
      api_endpoint: "MyString",
      api_key: "MyString"
    ))
  end

  it "renders new vendor form" do
    pending "fix"
    render

    assert_select "form[action=?][method=?]", vendors_path, "post" do

      assert_select "input[name=?]", "vendor[name]"

      assert_select "input[name=?]", "vendor[email]"

      assert_select "textarea[name=?]", "vendor[description]"

      assert_select "input[name=?]", "vendor[api_endpoint]"

      assert_select "input[name=?]", "vendor[api_key]"
    end
  end
end
