class JetFuel < ApplicationRecord
  validates_presence_of :volume, :unit

  # eventually we'll want a more dynamic way to get this,
  # a lookup or api or whatever, since it's subject to change.
  GLOBAL_CARBON_INTENSITY = "249.48 kgCO2 per MWh"

  def get_nodes
    @possible_nodes = []

    # Next rev: do this with http--an out and back--so it's proper API-like
    # there must be a more elegant way to do this
    if self.category.present? && self.vendor.present?
      @possible_nodes << Node.where("LOWER(category) = 'jet fuel' AND LOWER(owner) = ?", self.vendor.downcase).to_a
      logger.debug "--------> @possible_nodes2: #{@possible_nodes.flatten.inspect}"
    elsif self.category.present?
      @possible_nodes << Node.where("LOWER(category) = 'jet fuel'")
      logger.debug "--------> @possible_nodes3: #{@possible_nodes.flatten.inspect}"
    end

    logger.debug "--------> @possible_nodes4: #{@possible_nodes.flatten.inspect}"
    @possible_nodes.flatten
  end

end