module Transfirst
  class Wallet < API
    attr_accessor :full_name, :addrLn1, :addrLn2, :city,
                  :city, :state, :zipCode, :pan, :sec, :xprDt, :api


    def initialize(*args)
      api, attrs = *args
      @api = api
      @body = build_request(attrs)
    end

    private

    def build_request(attrs)
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
                xml[VERSION].prodType 5 #5 -debit/credit card
              end
              xml[VERSION].cust do
                xml[VERSION].type 0 #adding new customer
                xml[VERSION].contact do
                  xml[VERSION].fullName attrs[:full_name]
                  xml[VERSION].addrLn1 attrs[:addrLn1]
                  xml[VERSION].addrLn2 attrs[:addrLn2] if attrs[:addrLn2].present?
                  xml[VERSION].city attrs[:city]
                  xml[VERSION].state attrs[:state]
                  xml[VERSION].zipCode attrs[:zipCode]
                  xml[VERSION].type 1 #1 = Recurring
                  xml[VERSION].stat 1 #0 = Inactive
                end
                xml[VERSION].pmt do
                  xml[VERSION].type 0 #adding new wallet
                  xml[VERSION].card do
                    #xml[VERSION].type 1
                    xml[VERSION].pan attrs[:pan]
                    xml[VERSION].sec attrs[:sec]
                    xml[VERSION].xprDt attrs[:xprDt]
                  end
                  xml[VERSION].desc 'My Wallet'
                  xml[VERSION].indCode 2
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
