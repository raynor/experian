require 'experian/credit_profile/client'
require 'experian/credit_profile/request'
require 'experian/credit_profile/response'

module Experian
  module CreditProfile

    MATCH_CODES = {
      'A' => 'Deceased/Non-Issued Social Security Number',
      'B' => 'No Record Found',
      'C' => 'ID Match',
      'D' => 'ID Match to Other Name',
      'E' => 'ID No Match'
    }

    DB_HOST = 'CIS'
    DB_HOST_TEST = 'STAR'

    def self.db_host
      Experian.test_mode? ? DB_HOST_TEST : DB_HOST
    end

    # convenience method
    def self.check_credit(options = {}, request_options = {})
      Client.new.check_credit_profile(options, request_options)
    end

  end
end
