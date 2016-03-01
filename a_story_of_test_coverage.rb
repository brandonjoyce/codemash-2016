class SomeClassSomewhere
  def some_method_somewhere
    populate_request_data unless @document.error?
    populate_header_data unless @document.error?
  end
end
