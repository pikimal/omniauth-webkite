require 'spec_helper'

describe OmniAuth::Strategies::Webkite do
  let(:request) { double('Request', params: {}, cookies: {}, env: {}, scheme: 'http') }
  let(:app) { lambda { [200, {}, ["Hello"]] } }

  before :each do
    OmniAuth.config.test_mode = true
  end

  after :each do
    OmniAuth.config.test_mode = false
  end

  describe "#client_options" do
    let(:options) { {} }

    subject do
      OmniAuth::Strategies::Webkite.
        new(app, 'client_id', 'secret', options).tap do |strategy|
        strategy.stub(:request).and_return request
      end.client
    end

    its(:site) { should eq 'https://auth.webkite.com' }
    its(:authorize_url) { should eq 'https://auth.webkite.com/oauth/authorize' }
    its(:token_url) { should eq 'https://auth.webkite.com/oauth/token' }

    context 'overriding site' do
      let(:options) { { client_options: { 'site' => 'https://example.com' } } }
      its(:site) { should eq 'https://example.com' }
      its(:authorize_url) { should eq 'https://example.com/oauth/authorize' }
      its(:token_url) { should eq 'https://example.com/oauth/token' }
    end

  end

  describe 'strategy' do
    let(:url_base) { 'http://pikimal.com' }
    let(:options) { {} }
    let(:user_info) do
      {
        'uid' => '42',
        'name' => 'Boo',
        'email' => 'boo@foo.com'
      }
    end
    let(:token_opts) { {} }
    let(:token) do
      OAuth2::AccessToken.new(double('client'), 'xyzzy', token_opts)
    end

    before :each do
      request.stub(:url).and_return "#{url_base}/page/path"
    end

    subject do
      OmniAuth::Strategies::Webkite.
        new(app, 'client_id', 'secret', options).tap do |strategy|
        strategy.stub(:request).and_return request
        strategy.stub(:script_name).and_return ''
        strategy.stub(:raw_info).and_return user_info
        strategy.stub(:access_token).and_return token
      end
    end

    its(:callback_url) { should eq "#{url_base}/auth/webkite/callback" }

    context 'overriding callback path' do
      let(:options) { { callback_path: '/auth/webkite' } }
      its(:callback_url) { should eq "#{url_base}/auth/webkite" }
    end

    its(:uid) { should eq '42' }
    its(:extra) { should eq({ 'raw_info' => user_info }) }
    its(:info) { should eq({ name: 'Boo', email: 'boo@foo.com' }) }

    describe 'credentials' do
      subject do
        OmniAuth::Strategies::Webkite.
          new(app, 'client_id', 'secret', options).tap do |strategy|
          strategy.stub(:request).and_return request
          strategy.stub(:script_name).and_return ''
          strategy.stub(:raw_info).and_return user_info
          strategy.stub(:access_token).and_return token
        end.credentials
      end

      it { should be_a Hash }
      its(['token']) { should eq 'xyzzy' }
      its(['expires']) { should be_false }

      context 'token expires' do
        let(:token_opts) { { 'expires' => '42' } }
        its(['expires']) { should be_true }
      end
    end
  end

end
