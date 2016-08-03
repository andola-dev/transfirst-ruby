module Transfirst
  class WalletSale < API
    attr_accessor :amount, :api, :wallet_id

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
                xml[VERSION].prodType 7 #MERCHANT_PROD_TYPE
              end
              xml[VERSION].tranCode 14 #14 = Recurring(Manual) Auth/Settle, 0 = Auth Only
              xml[VERSION].reqAmt (attrs[:amount]*100).round ## should probably be in cents
              xml[VERSION].indCode 2
              xml[VERSION].recurMan do
                xml[VERSION].id attrs[:wallet_id]
              end
            end
          end
        end
      end
      req_builder.to_xml :save_with => Nokogiri::XML::Node::SaveOptions::NO_DECLARATION
    end
  end
end
