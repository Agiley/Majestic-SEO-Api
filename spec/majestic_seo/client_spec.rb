require File.expand_path('../../spec_helper', __FILE__)

describe "Majestic Seo Api Client"  do
  describe "initialization settings" do

    describe "with defaults" do
      before(:each) do
        @client = MajesticSeo::Api::Client.new
      end
    end

    describe "#get_index_item_info" do
      it "should send a correct request" do
        client      =   MajesticSeo::Api::Client.new
        
        urls        =   ["google.com", "yahoo.com"]
        parameters  =   {data_source: :historic}
        options     =   {timeout:     5}
        api_key     =   ::MajesticSeoApi.configuration.api_key

        expecting   =   {"datasource"     =>    :historic,
                         "items"          =>    2,
                         "item0"          =>    "google.com",
                         "item1"          =>    "yahoo.com",
                         "app_api_key"    =>    api_key,
                         "cmd"            =>    "GetIndexItemInfo"
                        }

        client.expects(:execute_request).with(expecting, options)
        response = client.get_index_item_info(urls, parameters, options)
      end
    end

  end
end
