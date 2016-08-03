module Transfirst
  class AccountVerification < API
    attr_accessor :addrLn1, :zipCode, :pan, :sec, :xprDt, :api

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
            xml[VERSION].send('SendTranRequest') do
              xml[VERSION].merc do
                xml[VERSION].id @api.gateway_id
                xml[VERSION].regKey @api.registration_key
                xml[VERSION].inType MERCHANT_WEB_SERVICE
              end
              xml[VERSION].tranCode 9 #Account Verification Only
              xml[VERSION].card do
                xml[VERSION].pan attrs[:pan]
                xml[VERSION].sec attrs[:sec]
                xml[VERSION].xprDt attrs[:xprDt]
              end
              xml[VERSION].contact do
                xml[VERSION].addrLn1 attrs[:addrLn1]
                xml[VERSION].zipCode attrs[:zipCode]
              end
            end
          end
        end
      end
      req_builder.to_xml :save_with => Nokogiri::XML::Node::SaveOptions::NO_DECLARATION
    end
  end
end
