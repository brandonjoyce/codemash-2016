module RequestMappers
  class PrescriberMapper < RequestMapperBase
    include ActionView::Helpers::NumberHelper
    include RequestMappers::AddressHelper

    delegate :prescriber, to: :document

    def map_prescriber # rubocop:disable Metrics/AbcSize
      {
        first_name: prescriber.first_name,
        last_name: prescriber.last_name,
        address: map_address_for(:prescriber),
        phone_number: number_to_phone(prescriber.phone),
        fax_number: number_to_phone(prescriber.fax),
        npi: prescriber.npi,
        speciality: prescriber.to_hash[:speciality],
      }
    end
  end
end
