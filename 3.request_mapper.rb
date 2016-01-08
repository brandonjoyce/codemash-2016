class CreateRequestMapper

  def initialize document
    @document = document
    @patient_mapper = RequestMappers::PatientMapper.new document
    @prescriber_mapper = RequestMappers::PrescriberMapper.new document
    @prescription_mapper = RequestMappers::PrescriptionMapper.new document
    @payer_mapper = RequestMappers::PayerMapper.new document
  end

  attr_reader :document, :patient_mapper, :prescriber_mapper,
              :prescription_mapper, :payer_mapper

  def request_data
    {
      patient: patient_mapper.map,
      prescriber: prescriber_mapper.map,
      prescription: prescription_mapper.map,
      payer: payer_mapper.map,
      state: document.patient.state,
    }
  end
end
