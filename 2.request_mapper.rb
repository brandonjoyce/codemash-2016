class CreateRequestMapper

  REQUEST_MAPPERS = [
    RequestMappers::PrescriberMapper,
    RequestMappers::PatientMapper,
    # ... and so on
  ]

  def initialize document
    @document = document
  end

  attr_reader :document

  def request_data
    {}.tap do |data|
      MAPPERS.each do |mapper|
        result.merge!(mapper.new(document).map)
      end
    end
  end
end
