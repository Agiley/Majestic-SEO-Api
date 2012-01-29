require File.expand_path('../../spec_helper', __FILE__)

describe MajesticSeo::Api::TopBackLinksResponse  do

  describe "invalid response from MajesticSeo" do
    before(:each) do
	    @xml        =   '<?xml version="1.0" encoding="utf-8"?><Result Code="FailedRequestViaAPI" ErrorMessage="API Key does not appear to be correct: API_KEY - &#39;api_key&#39;" FullError="Majestic12.SearchIndexReportResponse+ResponseException: API Key does not appear to be correct: API_KEY - &#39;api_key&#39;&#13;&#10;   at Majestic12.SearchIndexReportManager.Authenticate(SearchIndexReportRequest oReq) in W:\VersionFiles\WorldSource\MJ12searchLib\SearchIndexReportManager.cs:line 2411&#13;&#10;   at Majestic12.SearchIndexReportManager.RunReport(SearchConfig oConfig, SearchIndex oSI, SearchIndexReportRequest oReq, Boolean bAvoidQueueing, SearchIndexReportResponse&#38; oRes) in W:\VersionFiles\WorldSource\MJ12searchLib\SearchIndexReportManager.cs:line 2071"><GlobalVars/></Result>'
      @parsed     =   ::Nokogiri::XML(@xml, nil, "utf-8")
      @response   =   MajesticSeo::Api::TopBackLinksResponse.new(@parsed)
      @table      =   @response.tables["URL"]
    end

    it "should be an invalid response" do
      @response.success.should == false
    end

    it "should have an error message" do
      @response.error_message.should == "API Key does not appear to be correct: API_KEY - 'api_key'"
    end

    it "should have a stacktrace" do
      @response.stacktrace.should_not == ""
    end

    it "should have no data tables" do
      @response.tables.size.should == 0
    end

  end
end

