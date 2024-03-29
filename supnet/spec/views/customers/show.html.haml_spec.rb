require 'rails_helper'

RSpec.describe "customers/show", type: :view do
  before(:each) do
    assign(:customer, Customer.create!(
      name: "Name",
      email: "Email@test.com",
      description: "MyText",
      api_endpoint: "Api Endpoint",
      api_key: "Api Key"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Api Endpoint/)
    expect(rendered).to match(/Api Key/)
  end
end
