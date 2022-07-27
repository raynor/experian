require 'test_helper'

describe Experian::Client do

  before do
    stub_experian_uri_lookup
    @client = Experian::Client.new
    @client.stubs(:request).returns(stub(xml: 'fake xml content'))
  end

  it 'should set the correct content type header' do
    assert_equal 'application/x-www-form-urlencoded', @client.request_headers['Content-Type']
  end

  it 'should set the body to the url encoded request xml' do
    assert_equal 'NETCONNECT_TRANSACTION=fake+xml+content', @client.request_body
  end

end
