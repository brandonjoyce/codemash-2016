class CreateRequestMapper

  def initialize document
    @document = document
    @patient_mapper = RequestMappers::PatientMapper.new document
    @prescriber_mapper = RequestMappers::PrescriberMapper.new document
    # and so on...
  end

  attr_reader :document, :patient_mapper, :prescriber_mapper

  def request_data
    {
      patient: patient_mapper.map,
      prescriber: prescriber_mapper.map,
      # and so on...
    }
  end
end
