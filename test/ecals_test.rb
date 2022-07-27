require 'test_helper'

class EcalsTest < ActiveSupport::TestCase
  test 'url ends with .experian.com' do
    # ruby -Itest lib/experian/test/ecals_test.rb --name test_url_ends_with_.experian.com

    p 'Requirement: The URL returned from ECALS must end with .experian.com.'

    exception = assert_raises(Exception) {
      Experian::CreditProfile::Client.new.check_credit_profile({
        first_name: 'Jonathan',
        last_name: 'Consumer',
        ssn: '999999990',
        street: '10655 North Birch',
        zip: '91502',
        city: 'Burbank',
        state: 'CA'
      }, {
        ecals_uri: 'http://www.experian.com/lookupServlet1?lookupServiceName=AccessPoint&lookupServiceVersion=1.0&serviceName=NetConnect&serviceVersion=0.1&responseType=text/plain'
      })
    }

    p exception
  end

  test 'certificate match url' do
    # ruby -Itest lib/experian/test/ecals_test.rb --name test_certificate_match_url

    p 'Requirement: The URL in the certificate must match the URL retrieved from the ECALS transaction.'

    exception = assert_raises(Exception) {
      Experian::CreditProfile::Client.new.check_credit_profile({
        first_name: 'Jonathan',
        last_name: 'Consumer',
        ssn: '999999990',
        street: '10655 North Birch',
        zip: '91502',
        city: 'Burbank',
        state: 'CA'
      }, {
        ecals_uri: 'http://www.experian.com/lookupServlet1?lookupServiceName=AccessPoint&lookupServiceVersion=1.0&serviceName=NetConnect&serviceVersion=0.2&responseType=text/plain'
      })
    }

    p exception
  end

  test 'certificate valid and trusted' do
    # ruby -Itest lib/experian/test/ecals_test.rb --name test_certificate_valid_and_trusted

    p 'Requirement: The certificate must be valid and trusted.'

    exception = assert_raises(Exception) {
      Experian::CreditProfile::Client.new.check_credit_profile({
        first_name: 'Jonathan',
        last_name: 'Consumer',
        ssn: '999999990',
        street: '10655 North Birch',
        zip: '91502',
        city: 'Burbank',
        state: 'CA'
      }, {
        ecals_uri: 'http://www.experian.com/lookupServlet1?lookupServiceName=AccessPoint&lookupServiceVersion=1.0&serviceName=NetConnect&serviceVersion=0.3&responseType=text/plain'
      })
    }

    p exception
  end

  test 'certificate not expired' do
    # NOTE: Add address 205.174.34.81 to your local host table and associate it with https://ectst001a.ec.experian.com or ectst001a.ec.experian.com

    # ruby -Itest lib/experian/test/ecals_test.rb --name test_certificate_not_expired

    p 'Requirement: The certificate must be valid and trusted.'

    exception = assert_raises(Exception) {
      Experian::CreditProfile::Client.new.check_credit_profile({
        first_name: 'Jonathan',
        last_name: 'Consumer',
        ssn: '999999990',
        street: '10655 North Birch',
        zip: '91502',
        city: 'Burbank',
        state: 'CA'
      }, {
        ecals_uri: 'http://www.experian.com/lookupServlet1?lookupServiceName=AccessPoint&lookupServiceVersion=1.0&serviceName=NetConnect&serviceVersion=0.4&responseType=text/plain'
      })
    }

    p exception
  end
end