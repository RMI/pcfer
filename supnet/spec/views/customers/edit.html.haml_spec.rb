require 'rails_helper'

RSpec.describe "customers/edit", type: :view do
  let(:customer) {
    Customer.create!(
      name: "MyString",
      email: "test@test.com",
      description: "MyText",
      api_endpoint: "MyString",
      api_key: "MyString"
    )
  }

  before(:each) do
    assign(:customer, customer)
  end

  it "renders the edit customer form" do
    skip

    # render

    # assert_select "form[action=?][method=?]", customer_path(customer), "post" do

    #   assert_select "input[name=?]", "customer[name]"

    #   assert_select "input[name=?]", "customer[email]"

    #   assert_select "textarea[name=?]", "customer[description]"

    #   assert_select "input[name=?]", "customer[api_endpoint]"

    #   assert_select "input[name=?]", "customer[api_key]"
    # end
  end
end
