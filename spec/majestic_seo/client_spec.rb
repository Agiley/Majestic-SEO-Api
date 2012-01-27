require File.expand_path('../../spec_helper', __FILE__)

describe "Majestic Seo Api Client"  do
  describe "initialization settings" do

    describe "with defaults" do
      before(:each) do
        config = {"environment" =>  "sandbox", "api_key"  =>  "api_key"}
        MajesticSeo::Api::Client.any_instance.expects(:config).at_least_once.returns(config)
        @client = MajesticSeo::Api::Client.new
      end

      it "should contain a key" do
      	@client.api_key.should == "api_key"
      end

      it "should have the environment set to sandbox" do
      	@client.environment.should == :sandbox
      end

    end

    describe "#get_index_item_info" do
      it "should send a correct request" do
        client = MajesticSeo::Api::Client.new

        urls      =   ["google.com", "yahoo.com"]
        options   =   {:timeout => 5}

        expecting = {"datasource"     =>    "historic",
                     "items"          =>    2,
                     "item0"          =>    "google.com",
                     "item1"          =>    "yahoo.com",
                     "app_api_key"    =>    client.api_key,
                     "cmd"            =>    "GetIndexItemInfo"}

        client.expects(:execute_request).with(expecting, options[:timeout])
        response = client.get_index_item_info(urls, options)
      end
    end

    describe "#get_top_back_links" do
      it "should send a correct request" do
        client = MajesticSeo::Api::Client.new

        url       =   "google.com"
        options   =   {:timeout => 5}

        expecting = {"datasource"                 =>    "historic",
                     "URL"                        =>    "google.com",
                     "MaxSourceURLs"              =>    100,
                     "ShowDomainInfo"             =>    0,
                     "GetUrlData"                 =>    1,
                     "GetSubDomainData"           =>    0,
                     "GetRootDomainData"          =>    0,
                     "MaxSourceURLsPerRefDomain"  =>    -1,
                     "DebugForceQueue"            =>    0,
                     "app_api_key"                =>    client.api_key,
                     "cmd"                        =>    "GetTopBackLinks"}

        client.expects(:execute_request).with(expecting, options[:timeout])
        response = client.get_top_back_links(url, options)
      end
    end

  end
end

