require 'transfirst/ruby/version'
require 'savon'
require 'nokogiri'
require 'transfirst/transfirst_error'
require 'transfirst/response_codes'

module Transfirst
  class API
    ADD_ENTITY = 0
    UPDATE_ENTITY = 1
    STATUS_ACTIVE = 1
    STATUS_INACTIVE = 0
    NO_API_ERROR = 'No API object configured'
    RECURRING = 1
    VERSION='v1'
    MERCHANT_WEB_SERVICE = 1
    MERCHANT_PROD_TYPE = 5 #4 = ACH, 5 = Debit Card/Credit Card
    XSD_PATH='http://postilion/realtime/merchantframework/xsd/v1/'

    attr_reader :client, :gateway_id, :registration_key

    def initialize(credentials = {})
      @gateway_id = credentials.fetch(:gateway_id)
      @registration_key = credentials.fetch(:registration_key)
    end

    def make_request(opname, body)
      begin
        response = soap_client.call(opname, xml: body, soap_action: nil)
        response.body
      rescue Savon::SOAPFault => e
        Transfirst::TransfirstError.new(e).message
      end
    end


    def register
      case self.class.name
        when 'Transfirst::Customer', 'Transfirst::Wallet'
          @resp = api.make_request(:updt_recurr_prof, @body)
        when 'Transfirst::WalletSale', 'Transfirst::WalletRefund', 'Transfirst::AccountVerification'
          @resp = api.make_request(:send_tran, @body)
        else
      end
      @resp
    end

    private
    def soap_client
      document = wsdl_path
      @client ||= Savon::Client.new do
        ssl_verify_mode :none
        log true if ENV['DEBUG']
        pretty_print_xml true
        wsdl document
      end
    end

    def wsdl_path
      File.expand_path(File.join(__FILE__, '../transfirst/wsdl/transfirst-v1.wsdl'))
    end
  end
end
