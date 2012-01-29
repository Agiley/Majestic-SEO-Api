# -*- encoding : utf-8 -*-
require File.expand_path('../../spec_helper', __FILE__)

describe MajesticSeo::Api::ItemInfoResponse  do

#Example XML:
#<?xml version="1.0" encoding="utf-8"?>
#<Result Code="OK" ErrorMessage="" FullError="">
#    <GlobalVars FirstBackLinkDate="2006-06-06" IndexBuildDate="04/01/2012 09:14:02" IndexType="0" MostRecentBackLinkDate="2011-12-18" RecentBackLinksFromDate="2011-09-19" ServerBuild="2011-11-07 13:20:36" ServerName="PWRGURU" ServerVersion="1.0.4328.24018"/>
#  <DataTables Count="1">
#    <DataTable Name="Results" RowsCount="2" Headers="ItemNum|Item|ResultCode|Status|ExtBackLinks|RefDomains|AnalysisResUnitsCost|ACRank|ItemType|IndexedURLs|GetTopBackLinksAnalysisResUnitsCost|RefIPs|RefSubNets|RefDomainsEDU|ExtBackLinksEDU|RefDomainsGOV|ExtBackLinksGOV|RefDomainsEDU_Exact|ExtBackLinksEDU_Exact|RefDomainsGOV_Exact|ExtBackLinksGOV_Exact|CrawledFlag|LastCrawlDate|LastCrawlResult|RedirectFlag|FinalRedirectResult|OutDomainsExternal|OutLinksExternal|OutLinksInternal|LastSeen|Title|RedirectTo">
#      <Row>0|google.com|OK|Found|33536625553|15560001|33536625553|-1|1|5087871285|5000|2135470|363423|31636|147893369|22859|39850401|5833|43625720|6237|6983793|False| | |False| |0|0|0| | |http://www.google.nl</Row>
#      <Row>1|yahoo.com|OK|Found|16814018765|8374570|16814018765|-1|1|3845667299|5000|1345597|266044|17992|24506182|10441|12766565|4284|5810404|1217|1338346|False| | |False| |0|0|0| | |http://pl.yahoo.com/?p=us</Row>
#    </DataTable>
#  </DataTables>
#</Result>

  describe "successful ASCII response from MajesticSeo" do
    before(:each) do
      #We need to keep the XML on one line - JRuby goes bonanza otherwise
      @xml        =   '<?xml version="1.0" encoding="utf-8"?><Result Code="OK" ErrorMessage="" FullError=""><GlobalVars FirstBackLinkDate="2006-06-06" IndexBuildDate="04/01/2012 09:14:02" IndexType="0" MostRecentBackLinkDate="2011-12-18" RecentBackLinksFromDate="2011-09-19" ServerBuild="2011-11-07 13:20:36" ServerName="PWRGURU" ServerVersion="1.0.4328.24018"/><DataTables Count="1"><DataTable Name="Results" RowsCount="2" Headers="ItemNum|Item|ResultCode|Status|ExtBackLinks|RefDomains|AnalysisResUnitsCost|ACRank|ItemType|IndexedURLs|GetTopBackLinksAnalysisResUnitsCost|RefIPs|RefSubNets|RefDomainsEDU|ExtBackLinksEDU|RefDomainsGOV|ExtBackLinksGOV|RefDomainsEDU_Exact|ExtBackLinksEDU_Exact|RefDomainsGOV_Exact|ExtBackLinksGOV_Exact|CrawledFlag|LastCrawlDate|LastCrawlResult|RedirectFlag|FinalRedirectResult|OutDomainsExternal|OutLinksExternal|OutLinksInternal|LastSeen|Title|RedirectTo"><Row>0|google.com|OK|Found|33536625553|15560001|33536625553|-1|1|5087871285|5000|2135470|363423|31636|147893369|22859|39850401|5833|43625720|6237|6983793|False| | |False| |0|0|0| | |http://www.google.nl</Row><Row>1|yahoo.com|OK|Found|16814018765|8374570|16814018765|-1|1|3845667299|5000|1345597|266044|17992|24506182|10441|12766565|4284|5810404|1217|1338346|False| | |False| |0|0|0| | |http://pl.yahoo.com/?p=us</Row></DataTable></DataTables></Result>'
      @response   =   HttpUtilities::Http::Response.new(@xml, nil, {:format => :xml})
      @response   =   MajesticSeo::Api::ItemInfoResponse.new(@response)
      @table      =   @response.tables["Results"]
    end

    it "should be a valid response" do
      @response.success.should == true
    end

    it "should not have an error message" do
      @response.error_message.should == ""
    end

    it "should have global variables set" do
      @response.global_variables["most_recent_back_link_date"].should == "2011-12-18"
      @response.global_variables["index_type"].should == "0"
    end

    it "should have one returned data table" do
      @response.tables.size.should == 1
    end

    it "should have a data table with the name 'Results'" do
      @table.should_not be_nil
    end

    it "should have a data table with the name 'Results' containing 2 rows" do
      @table.row_count.should == 2
    end

    it "should have results for google.com" do
      google_row = @response.items[0]
      
      google_row.url.should                 ==  "google.com"
      google_row.type.should                ==  :root_domain
      google_row.result_code.should         ==  "OK"
      google_row.success.should             ==  true
      google_row.status.should              ==  "Found"
      google_row.external_backlinks.should  ==  33536625553
    end

    it "should have results for yahoo.com" do
      yahoo_row = @response.items[1]
      
      yahoo_row.url.should            ==  "yahoo.com"
      yahoo_row.type.should           ==  :root_domain
      yahoo_row.result_code.should    ==  "OK"
      yahoo_row.success.should        ==  true
      yahoo_row.status.should         ==  "Found"
      yahoo_row.indexed_urls.should   ==  3845667299
    end

  end

#Example XML:
#<?xml version="1.0" encoding="utf-8"?>
#<Result Code="OK" ErrorMessage="" FullError="">
#  <GlobalVars FirstBackLinkDate="2006-06-06" IndexBuildDate="04/01/2012 09:14:02" IndexType="0" MostRecentBackLinkDate="2011-12-18" RecentBackLinksFromDate="2011-09-19" ServerBuild="2011-11-07 13:20:36" ServerName="PWRGURU" ServerVersion="1.0.4328.24018"/>
#  <DataTables Count="1">
#    <DataTable Name="Results" RowsCount="1" Headers="ItemNum|Item|ResultCode|Status|ExtBackLinks|RefDomains|AnalysisResUnitsCost|ACRank|ItemType|IndexedURLs|GetTopBackLinksAnalysisResUnitsCost|RefIPs|RefSubNets|RefDomainsEDU|ExtBackLinksEDU|RefDomainsGOV|ExtBackLinksGOV|RefDomainsEDU_Exact|ExtBackLinksEDU_Exact|RefDomainsGOV_Exact|ExtBackLinksGOV_Exact|CrawledFlag|LastCrawlDate|LastCrawlResult|RedirectFlag|FinalRedirectResult|OutDomainsExternal|OutLinksExternal|OutLinksInternal|LastSeen|Title|RedirectTo">
#      <Row>0|aftonbladet.se|OK|Found|54063780|128804|54063780|-1|1|5658886|5000|43589|23882|279|2396|35|179|120|496|4|13|False| | |False| |0|0|0| | Aftonbladet: Sveriges nyhetskälla och mötesplats |http://www.aftonbladet.se</Row>
#    </DataTable>
#  </DataTables>
#</Result>

  describe "successful utf-8 response from MajesticSeo" do
    before(:each) do
      #We need to keep the XML on one line - JRuby goes bonanza otherwise
      @xml        =   '<?xml version="1.0" encoding="utf-8"?><Result Code="OK" ErrorMessage="" FullError=""><GlobalVars FirstBackLinkDate="2006-06-06" IndexBuildDate="04/01/2012 09:14:02" IndexType="0" MostRecentBackLinkDate="2011-12-18" RecentBackLinksFromDate="2011-09-19" ServerBuild="2011-11-07 13:20:36" ServerName="PWRGURU" ServerVersion="1.0.4328.24018"/><DataTables Count="1"><DataTable Name="Results" RowsCount="1" Headers="ItemNum|Item|ResultCode|Status|ExtBackLinks|RefDomains|AnalysisResUnitsCost|ACRank|ItemType|IndexedURLs|GetTopBackLinksAnalysisResUnitsCost|RefIPs|RefSubNets|RefDomainsEDU|ExtBackLinksEDU|RefDomainsGOV|ExtBackLinksGOV|RefDomainsEDU_Exact|ExtBackLinksEDU_Exact|RefDomainsGOV_Exact|ExtBackLinksGOV_Exact|CrawledFlag|LastCrawlDate|LastCrawlResult|RedirectFlag|FinalRedirectResult|OutDomainsExternal|OutLinksExternal|OutLinksInternal|LastSeen|Title|RedirectTo"><Row>0|aftonbladet.se|OK|Found|54063780|128804|54063780|-1|1|5658886|5000|43589|23882|279|2396|35|179|120|496|4|13|False| | |False| |0|0|0| | Aftonbladet: Sveriges nyhetskälla och mötesplats |http://www.aftonbladet.se</Row></DataTable></DataTables></Result>'
      @response   =   HttpUtilities::Http::Response.new(@xml, nil, {:format => :xml})
      @response   =   MajesticSeo::Api::ItemInfoResponse.new(@response)
      @table      =   @response.tables["Results"]
    end

    it "should be a valid response" do
      @response.success.should == true
    end

    it "should not have an error message" do
      @response.error_message.should == ""
    end

    it "should have global variables set" do
      @response.global_variables["most_recent_back_link_date"].should == "2011-12-18"
      @response.global_variables["index_type"].should == "0"
    end

    it "should have one returned data table" do
      @response.tables.size.should == 1
    end

    it "should have a data table with the name 'Results'" do
      @table.should_not be_nil
    end

    it "should have a data table with the name 'Results' containing 2 rows" do
      @table.row_count.should == 1
    end

    it "should have results for aftonbladet.se" do
      row = @response.items[0]
      
      row.url.should                  ==  "aftonbladet.se"
      row.title.should                ==  "Aftonbladet: Sveriges nyhetskälla och mötesplats"
      row.type.should                 ==  :root_domain
      row.result_code.should          ==  "OK"
      row.success.should              ==  true
      row.status.should               ==  "Found"
      row.external_backlinks.should   ==  54063780
      row.referring_domains.should    ==  128804
    end

  end
end

