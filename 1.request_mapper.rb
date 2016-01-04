class CreateRequestMapper
  include ActionView::Helpers::NumberHelper

  PAYER_TO_QUALIFIER = 'PY'.freeze

  def initialize document
    @document = document
  end

  attr_reader :document

  def request_data
    {
      patient: map_patient,
      state: document.patient.state,
      prescription: map_prescription,
      prescriber: map_prescriber,
      payer: payer_info,
    }
  end

  private

  def map_prescription
    {
      drug_id: document.drug.ndc,
      quantity: document.drug.quantity,
      quantity_unit_of_measure: document.drug.quantity_qualifier,
      days_supply: document.drug.days_supply,
      strength: document.drug.strength,
    }
  end

  def map_prescriber
    {
      first_name: document.prescriber.first_name,
      last_name: document.prescriber.last_name,
      address: map_prescriber_address,
      phone_number: prescriber_phone,
      fax_number: number_to_phone(document.prescriber.fax),
      npi: document.prescriber.npi,
    }
  end

  def prescriber_phone
    number_to_phone(document.prescriber.phone)
  end

  def map_prescriber_address
    {
      street_1: document.prescriber.address_line_1,
      street_2: document.prescriber.address_line_2,
      city: document.prescriber.city,
      state: document.prescriber.state,
      zip: document.prescriber.zip,
    }
  end

  def map_patient
    {
      first_name: document.patient.first_name,
      last_name: document.patient.last_name,
      date_of_birth: patient_date_of_birth,
      gender: document.patient.gender,
      phone_number: patient_phone_number,
      member_id: document.patient.member_number,
      address: map_patient_address,
    }
  end

  def patient_date_of_birth
    NcpdpHelpers.to_cmm_date(document.patient.date_of_birth)
  end

  def patient_phone_number
    number_to_phone(document.patient.phone)
  end

  def map_patient_address
    {
      street_1: document.patient.address_line_1,
      street_2: document.patient.address_line_2,
      city: document.patient.city,
      state: document.patient.state,
      zip: document.patient.zip,
    }
  end

  def payer_info
    {
      bin: bin,
      pcn: pcn,
      group_id: group_id,
      form_search_text: payer_name,
    }.reject { |_, v| v.blank? }
  end

  def bin_location_number
    document
      .benefits
      .payer_identification
      .bin_location_number
  end

  def to_field_has_payer_info?
    document.to_hash[:to_qualifier] == PAYER_TO_QUALIFIER
  end

  def bin
    value = (json_payer_info[:bin] || to_payer_info[:bin] || bin_location_number)
    value.presence && value.rjust(6, '0')
  end

  def pcn
    json_payer_info[:pcn] || to_payer_info[:pcn] || benefits_pcn
  end

  def group_id
    json_payer_info[:group_id] || to_payer_info[:group_id] || benefits_hash[:group_id]
  end

  def payer_name
    benefits_hash[:payer_name]
  end

  def benefits_hash
    document.benefits.to_hash
  end

  def to_field_at position
    to_field_has_payer_info? ? to.split(':')[position] : nil
  end

  def benefits_pcn
    benefits_hash[:payer_identification][:processor_identification_number]
  end

  def to_payer_info
    {
      bin: to_field_at(0),
      pcn: to_field_at(1),
      group_id: to_field_at(2),
    }.delete_if { |_, v| v == Settings.epic.generic_dxo }
  end

  def to_has_org_id?
    to.include?(Settings.org_id_prefix)
  end

  def json_payer_info
    to_has_org_id? ? payer_json : {}
  end

  def org_id
    to.split(':').last.to_i
  end

  def payer_json
    @payer_json ||= PayerJson.new(Rails.root.join('config/payers.json')).find(org_id)
  end
end
