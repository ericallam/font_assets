require 'spec_helper'
require 'font_assets/middleware'

describe FontAssets::Middleware do
  it 'passes all Rack::Lint checks' do
    app = Rack::Lint.new(load_app)
    request app, '/'
  end

  context 'for GET requests' do
    context 'to font assets' do
      context 'with an app that allows ssl' do
        let(:app) { load_app 'http://test.origin', allow_ssl: true }

        context 'and makes a https request' do
          let(:response) { request app, 'https://test.origin/test.ttf' }

          context 'the response headers' do
            subject { response[1] }

            its(["Access-Control-Allow-Headers"]) { should == "x-requested-with" }
            its(["Access-Control-Max-Age"]) { should == "3628800" }
            its(['Access-Control-Allow-Methods']) { should == 'GET' }
            its(['Access-Control-Allow-Origin']) { should == 'https://test.origin' }
            its(['Content-Type']) { should == 'application/x-font-ttf' }
          end
        end

        context 'and makes a http request' do
          let(:response) { request app, '/test.ttf' }

          context 'the response headers' do
            subject { response[1] }

            its(["Access-Control-Allow-Headers"]) { should == "x-requested-with" }
            its(["Access-Control-Max-Age"]) { should == "3628800" }
            its(['Access-Control-Allow-Methods']) { should == 'GET' }
            its(['Access-Control-Allow-Origin']) { should == 'http://test.origin' }
            its(['Content-Type']) { should == 'application/x-font-ttf' }
          end
        end

      end

      context 'with an app that allows ssl from any origin' do
        let(:app) { load_app '*', allow_ssl: true }

        context 'and makes an https request' do
          let(:response) { request app, 'https://test.origin/test.ttf' }

          context 'the response headers' do
            subject { response[1] }

            its(["Access-Control-Allow-Headers"]) { should == "x-requested-with" }
            its(["Access-Control-Max-Age"]) { should == "3628800" }
            its(['Access-Control-Allow-Methods']) { should == 'GET' }
            its(['Access-Control-Allow-Origin']) { should == '*' }
            its(['Content-Type']) { should == 'application/x-font-ttf' }
          end
        end

        context 'and makes an http request' do
          let(:response) { request app, 'http://test.origin/test.ttf' }

          context 'the response headers' do
            subject { response[1] }

            its(["Access-Control-Allow-Headers"]) { should == "x-requested-with" }
            its(["Access-Control-Max-Age"]) { should == "3628800" }
            its(['Access-Control-Allow-Methods']) { should == 'GET' }
            its(['Access-Control-Allow-Origin']) { should == '*' }
            its(['Content-Type']) { should == 'application/x-font-ttf' }
          end
        end
      end

      context 'with an app with just the origin specified' do
        let(:app) { load_app 'http://test.origin' }
        let(:response) { request app, '/test.ttf' }

        context 'the response headers' do
          subject { response[1] }

          its(["Access-Control-Allow-Headers"]) { should == "x-requested-with" }
          its(["Access-Control-Max-Age"]) { should == "3628800" }
          its(['Access-Control-Allow-Methods']) { should == 'GET' }
          its(['Access-Control-Allow-Origin']) { should == 'http://test.origin' }
          its(['Content-Type']) { should == 'application/x-font-ttf' }
        end
      end
    end

    context 'to non-font assets' do
      let(:app) { load_app }
      let(:response) { request app, '/' }

      context 'the response headers' do
        subject { response[1] }

        its(["Access-Control-Allow-Headers"]) { should be_nil }
        its(["Access-Control-Max-Age"]) { should be_nil }
        its(['Access-Control-Allow-Methods']) { should be_nil }
        its(['Access-Control-Allow-Origin']) { should be_nil }
        its(['Content-Type']) { should == 'text/plain' }
      end
    end
  end

  context 'for OPTIONS requests' do
    let(:app) { load_app 'http://test.options' }
    let(:response) { request app, '/test.ttf', :method => 'OPTIONS' }

    context 'the response headers' do
      subject { response[1] }

      its(["Access-Control-Allow-Headers"]) { should == "x-requested-with" }
      its(["Access-Control-Max-Age"]) { should == "3628800" }
      its(['Access-Control-Allow-Methods']) { should == 'GET' }
      its(['Access-Control-Allow-Origin']) { should == 'http://test.options' }

      it 'should not contain a Content-Type' do
        subject['Content-Type'].should be_nil
      end
    end

    context 'the response body' do
      subject { response[2] }
      it { should be_empty }
    end
  end


  private


  def load_app(origin = 'http://test.local', options={})
    FontAssets::Middleware.new(inner_app, origin, options)
  end

  def inner_app
    lambda { |env| [200, {'Content-Type' => 'text/plain'}, 'Success'] }
  end

  def request(app, path, options = {})
    app.call Rack::MockRequest.env_for(path, options)
  end
end
