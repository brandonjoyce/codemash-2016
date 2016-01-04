module RequestMappers
  module AddressHelper
    def map_address_for entity
      entity_address = document.to_hash[entity]
      {
        street_1: entity_address[:address_line_1],
        street_2: entity_address[:address_line_2],
        city: entity_address[:city],
        state: entity_address[:state],
        zip: entity_address[:zip],
      }
    end
  end
end
