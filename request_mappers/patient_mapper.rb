module RequestMappers
  class PatientMapper < RequestMapperBase
    include ActionView::Helpers::NumberHelper
    include RequestMappers::AddressHelper

    delegate :patient, to: :document

    def map_patient # rubocop:disable Metrics/AbcSize
      {
        first_name: patient.first_name,
        last_name: patient.last_name,
        date_of_birth: NcpdpHelpers.to_cmm_date(document.patient.date_of_birth),
        gender: patient.gender,
        phone_number: number_to_phone(document.patient.phone),
        member_id: patient.member_number,
        address: map_address_for(:patient),
        pbm_member_id: document.to_hash[:benefits].andand[:pbm_member_id],
      }
    end
  end
end
