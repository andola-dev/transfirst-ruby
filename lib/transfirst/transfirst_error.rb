module Transfirst
  class TransfirstError < StandardError
    CODES = {
        '50000' => 'Undefined error code. Please check the error message.',
        '50001' => 'Database exception.',
        '50002' => 'Unhandled exception.',
        '50003' => 'This is returned if the following is true: No response was received from the upstream entity (i.e., eSocket Server) for a given amount of time. Default is 30 seconds.',
        '50004' => 'No record found.',
        '50005' => 'Too many records found.',
        '50006' => 'Record already exists.',
        '50007' => 'Database access failure.',
        '50008' => 'Authentication failed because of incomplete information (e.g., password not specified). No record updated.',
        '50009' => 'No record updated.',
        '50010' => 'Access denied.',
        '50011' => 'Schema validation error.',
        '50012' => 'Authentication failed because of wrong information (e.g., wrong password).',
        '50013' => 'System failure.',
        '50014' => 'User is active but locked.',
        '50015' => 'User is inactive.',
        '50016' => 'User is inactive and locked.',
        '50017' => 'Password is expired.',
        '50019' => 'User must change password.',
        '50020' => 'Old password and new password are the same but not expected.',
        '50021' => 'Request is expected but not set.',
        '50022' => 'User is not linked to a merchant or group.',
        '50023' => 'Password or Registration Key failed WSDL validation.',
        '50024' => 'Failed to send email.',
        '50025' => 'User ID and password are set, but Merchant ID is not set.',
        '50026' => 'Active/Active initialization failed.',
        '50027' => 'Encryption/decryption failed',
        '800002' => 'Given Credentials are not authenticated and/or Access Denied'
    }

    attr_accessor :error_code, :error_string

    def initialize(e)
      @soap_fault = e
      @error_code = e.to_hash[:fault][:detail][:system_fault][:error_code]
      @error_string = CODES[@error_code]
    end

    def message
      err_string = 'Service Error'
      if !error_code.blank? and !error_string.blank?
        error_details = " -- #{@error_code} - #{@error_string}"
        err_string += error_details
      end
      err_string
    end
  end
  
end
