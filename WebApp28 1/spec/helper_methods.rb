module HelperMethods

  def check_for_failed_validation(testee, field, expected_number_of_errors)
    expect(testee).to_not be_valid
    expect(testee).to have(expected_number_of_errors).errors_on(field)
  end

end
