class Node < ApplicationRecord
  validates_presence_of :owner, :category, :url

  def get_carbon_intensity
    # irl this would hit the API and get the value--and it will soon! but for now...
    "200.00 kgCO2 per MWh"
  end

end
