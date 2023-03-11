require 'rails_helper'

RSpec.describe "customers/new", type: :view do
  before(:each) do
    assign(:customer, Customer.new(
      name: "MyString",
      email: "MyString",
      description: "MyText",
      api_endpoint: "MyString",
      api_key: "MyString"
    ))
  end

  it "renders new customer form" do
    render

    assert_select "form[action=?][method=?]", customers_path, "post" do

      assert_select "input[name=?]", "customer[name]"

      assert_select "input[name=?]", "customer[email]"

      assert_select "textarea[name=?]", "customer[description]"

      assert_select "input[name=?]", "customer[api_endpoint]"

      assert_select "input[name=?]", "customer[api_key]"
    end
  end
end
