module Transfirst
  class Customer < API
    BUSINESS_PHONE = 3
    RECURRING_PAYMENT = 1

    FETCH_NODE = 'custCrta'
    FETCH_ID = 'id'

    attr_accessor :full_name, :phone_number, :address_line1, :address_line2,
                  :city, :state, :zip_code, :country, :email, :tf_id, :api, :status

    def initialize(*args)
      api, attrs = *args
      @api = api
      @body = build_request(attrs)
    end

    private

    def build_request attrs
      namespaces = {
          'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
          "xmlns:#{VERSION}" => XSD_PATH
      }
      req_builder = Nokogiri::XML::Builder.new do |xml|
        xml['soapenv'].Envelope(namespaces) do
          xml['soapenv'].Header
          xml['soapenv'].Body do
            xml[VERSION].send('UpdtRecurrProfRequest') do
              xml[VERSION].merc do
                xml[VERSION].id @api.gateway_id
                xml[VERSION].regKey @api.registration_key
                xml[VERSION].inType MERCHANT_WEB_SERVICE
              end
              xml[VERSION].cust do
                xml[VERSION].type 0 #0 adding new customer 1 updating customer
                xml[VERSION].contact do
                  xml[VERSION].fullName attrs[:full_name]
                  xml[VERSION].ctry 'US'
                  xml[VERSION].type 1 #This is an indicator of where the customer profile information is used. 1 = Recurring
                  xml[VERSION].stat 1 #0 = Inactive
                end
              end
            end
          end
        end
      end
      req_builder.to_xml :save_with => Nokogiri::XML::Node::SaveOptions::NO_DECLARATION
    end
  end
end
