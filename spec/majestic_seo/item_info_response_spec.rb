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
      @parsed     =   ::Nokogiri::XML(@xml, nil, "utf-8")
      @response   =   MajesticSeo::Api::ItemInfoResponse.new(@parsed)
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
  #	<GlobalVars FirstBackLinkDate="2006-06-06" IndexBuildDate="04/01/2012 09:14:02" IndexType="0" MostRecentBackLinkDate="2011-12-18" RecentBackLinksFromDate="2011-09-19" ServerBuild="2011-11-07 13:20:36" ServerName="PWRGURU" ServerVersion="1.0.4328.24018"/>
  #	<DataTables Count="1">
  #		<DataTable Name="Results" RowsCount="20" Headers="ItemNum|Item|ResultCode|Status|ExtBackLinks|RefDomains|AnalysisResUnitsCost|ACRank|ItemType|IndexedURLs|GetTopBackLinksAnalysisResUnitsCost|RefIPs|RefSubNets|RefDomainsEDU|ExtBackLinksEDU|RefDomainsGOV|ExtBackLinksGOV|RefDomainsEDU_Exact|ExtBackLinksEDU_Exact|RefDomainsGOV_Exact|ExtBackLinksGOV_Exact|CrawledFlag|LastCrawlDate|LastCrawlResult|RedirectFlag|FinalRedirectResult|OutDomainsExternal|OutLinksExternal|OutLinksInternal|LastSeen|Title|RedirectTo">
  #			<Row>0|http://www.playedonline.com|OK|Found|1870925|14631|1870925|10|3|1|5000|9229|6280|28|76|2|3|15|24|0|0|True|2011-12-18|DownloadedSuccessfully|False| |11|11|56| |Free Online Games - Free Games Played Online| </Row>
  #			<Row>1|playedonline.com|OK|Found|3346330|23456|3346330|-1|1|413472|5000|14377|9381|44|118|2|5|16|34|0|0|False| | |False| |0|0|0| |Free Online Games - Free Games Played Online|http://www.playedonline.com</Row>
  #			<Row>2|http://en.wikipedia.org/wiki/online_and_offline|OK|Found|6|5|6|3|3|1|5000|5|5|0|0|0|0|0|0|0|0|False| | |False| |0|0|0|2010-12-09| | </Row>
  #			<Row>3|en.wikipedia.org|OK|Found|4369655183|3923979|4369655183|-1|2|167450964|5000|916134|204062|10244|11824736|3772|1527467|3416|4775867|960|769650|False| | |False| |0|0|0| | |http://en.wikipedia.org/wiki/Main_Page</Row>
  #			<Row>4|http://www.onlinesbi.com|OK|Found|27828|2356|27828|9|3|1|5000|1340|1086|8|24|10|131|1|1|0|0|True|2011-12-18|ConnectFailure|False| |0|0|0| | | </Row>
  #			<Row>5|onlinesbi.com|OK|Found|46519|3823|46519|-1|1|1355|5000|2352|1852|15|51|18|157|5|5|0|0|False| | |False| |0|0|0| | |https://www.onlinesbi.com</Row>
  #			<Row>6|http://www.freeonlineusers.com|OK|Found|41652276|19271|41652276|11|3|1|5000|9386|6220|58|5049|20|1100|3|21|0|0|True|2011-12-18|DownloadedSuccessfully|False| |1|2|4| |Free Online Users - Online Users Counter| </Row>
  #			<Row>7|freeonlineusers.com|OK|Found|41733729|19968|41733729|-1|1|1053|5000|9769|6469|71|5087|23|1111|3|21|0|0|False| | |False| |0|0|0| |Free Online Users - Online Users Counter| </Row>
  #			<Row>8|http://www.online.no|OK|Found|152533|4469|152533|9|3|1|5000|2382|1916|7|224|0|0|3|4|0|0|True|2011-12-18|DownloadedSuccessfully|False| |23|70|72| |Telenor Online - Online.no| </Row>
  #			<Row>9|online.no|OK|Found|6969824|90197|6969824|-1|1|1071412|5000|41728|24437|488|4419|39|122|256|2631|14|32|False| | |False| |0|0|0| |Telenor Online - Online.no| </Row>
  #			<Row>10|http://www.onlinenews.com.pk|OK|Found|21544|1171|21544|8|3|1|5000|778|670|4|4|4|41|3|3|2|2|True|2011-12-18|DownloadedSuccessfully|False| |2|2|27| |ONLINE - International News Network| </Row>
  #			<Row>11|onlinenews.com.pk|OK|Found|103266|9203|103266|-1|1|82366|5000|4900|3857|62|194|15|111|47|163|7|27|False| | |False| |0|0|0| |ONLINE - International News Network| </Row>
  #			<Row>12|http://www.online.net|OK|Found|458339|19076|458339|11|3|1|5000|6133|4679|16|19|14|14|7|7|8|8|True|2011-12-18|DownloadedSuccessfully|False| |3|3|27| |Hébergement mutualisé serveurs dédiés - Online.net| </Row>
  #			<Row>13|online.net|OK|Found|6019818|67627|6019818|-1|1|222450|5000|14134|9284|46|204|30|94|19|121|15|32|False| | |False| |0|0|0| |Hébergement mutualisé serveurs dédiés - Online.net|http://www.online.net</Row>
  #			<Row>14|http://www.miniclip.com|OK|Found|2789543|55512|2789543|12|3|1|5000|31727|19723|362|17689|40|180|141|937|3|7|True|2011-12-18|HTTP_301_PermanentRedirect|True|DownloadedSuccessfully|0|0|0| | |http://www.miniclip.com/games/en</Row>
  #			<Row>15|miniclip.com|OK|Found|20615291|169135|20615291|-1|1|6966761|5000|88242|41560|955|68431|163|2236|296|3602|13|23|False| | |False| |0|0|0| | |http://www.miniclip.com/games/en</Row>
  #			<Row>16|https://webmail.online.nl|OK|Found|4166|161|4166|6|3|1|5000|103|100|0|0|0|0|0|0|0|0|True|2011-12-18|DownloadedSuccessfully|False| |1|4|0| |Veilig en razendsnel internet bij Online| </Row>
  #			<Row>17|webmail.online.nl|OK|Found|8934|440|8934|-1|2|153|5000|260|239|0|0|0|0|0|0|0|0|False| | |False| |0|0|0| |Veilig en razendsnel internet bij Online|https://webmail.online.nl</Row>
  #			<Row>18|http://www.fastonlineusers.com|OK|Found|42861832|21195|42861832|11|3|1|5000|9977|6604|62|6544|15|552|15|777|0|0|True|2011-12-18|DownloadedSuccessfully|False| |2|2|6| |Show online Users - Count your online vistis with fastonlineusers| </Row>
  #			<Row>19|fastonlineusers.com|OK|Found|43224699|21945|43224699|-1|1|34121|5000|10412|6907|79|6813|16|567|16|779|0|0|False| | |False| |0|0|0| |Show online Users - Count your online vistis with fastonlineusers| </Row>
  #		</DataTable>
  #	</DataTables>
  #</Result>
  describe "successful ASCII response with custom headers from MajesticSeo" do
    before(:each) do
      #We need to keep the XML on one line - JRuby goes bonanza otherwise
      @xml        =   '<?xml version="1.0" encoding="utf-8"?><Result Code="OK" ErrorMessage="" FullError=""><GlobalVars FirstBackLinkDate="2006-06-06" IndexBuildDate="04/01/2012 09:14:02" IndexType="0" MostRecentBackLinkDate="2011-12-18" RecentBackLinksFromDate="2011-09-19" ServerBuild="2011-11-07 13:20:36" ServerName="PWRGURU" ServerVersion="1.0.4328.24018"/><DataTables Count="1"><DataTable Name="Results" RowsCount="20" Headers="ItemNum|Item|ResultCode|Status|ExtBackLinks|RefDomains|AnalysisResUnitsCost|ACRank|ItemType|IndexedURLs|GetTopBackLinksAnalysisResUnitsCost|RefIPs|RefSubNets|RefDomainsEDU|ExtBackLinksEDU|RefDomainsGOV|ExtBackLinksGOV|RefDomainsEDU_Exact|ExtBackLinksEDU_Exact|RefDomainsGOV_Exact|ExtBackLinksGOV_Exact|CrawledFlag|LastCrawlDate|LastCrawlResult|RedirectFlag|FinalRedirectResult|OutDomainsExternal|OutLinksExternal|OutLinksInternal|LastSeen|Title|RedirectTo"><Row>0|http://www.playedonline.com|OK|Found|1870925|14631|1870925|10|3|1|5000|9229|6280|28|76|2|3|15|24|0|0|True|2011-12-18|DownloadedSuccessfully|False| |11|11|56| |Free Online Games - Free Games Played Online| </Row><Row>1|playedonline.com|OK|Found|3346330|23456|3346330|-1|1|413472|5000|14377|9381|44|118|2|5|16|34|0|0|False| | |False| |0|0|0| |Free Online Games - Free Games Played Online|http://www.playedonline.com</Row><Row>2|http://en.wikipedia.org/wiki/online_and_offline|OK|Found|6|5|6|3|3|1|5000|5|5|0|0|0|0|0|0|0|0|False| | |False| |0|0|0|2010-12-09| | </Row><Row>3|en.wikipedia.org|OK|Found|4369655183|3923979|4369655183|-1|2|167450964|5000|916134|204062|10244|11824736|3772|1527467|3416|4775867|960|769650|False| | |False| |0|0|0| | |http://en.wikipedia.org/wiki/Main_Page</Row><Row>4|http://www.onlinesbi.com|OK|Found|27828|2356|27828|9|3|1|5000|1340|1086|8|24|10|131|1|1|0|0|True|2011-12-18|ConnectFailure|False| |0|0|0| | | </Row><Row>5|onlinesbi.com|OK|Found|46519|3823|46519|-1|1|1355|5000|2352|1852|15|51|18|157|5|5|0|0|False| | |False| |0|0|0| | |https://www.onlinesbi.com</Row><Row>6|http://www.freeonlineusers.com|OK|Found|41652276|19271|41652276|11|3|1|5000|9386|6220|58|5049|20|1100|3|21|0|0|True|2011-12-18|DownloadedSuccessfully|False| |1|2|4| |Free Online Users - Online Users Counter| </Row><Row>7|freeonlineusers.com|OK|Found|41733729|19968|41733729|-1|1|1053|5000|9769|6469|71|5087|23|1111|3|21|0|0|False| | |False| |0|0|0| |Free Online Users - Online Users Counter| </Row><Row>8|http://www.online.no|OK|Found|152533|4469|152533|9|3|1|5000|2382|1916|7|224|0|0|3|4|0|0|True|2011-12-18|DownloadedSuccessfully|False| |23|70|72| |Telenor Online - Online.no| </Row><Row>9|online.no|OK|Found|6969824|90197|6969824|-1|1|1071412|5000|41728|24437|488|4419|39|122|256|2631|14|32|False| | |False| |0|0|0| |Telenor Online - Online.no| </Row><Row>10|http://www.onlinenews.com.pk|OK|Found|21544|1171|21544|8|3|1|5000|778|670|4|4|4|41|3|3|2|2|True|2011-12-18|DownloadedSuccessfully|False| |2|2|27| |ONLINE - International News Network| </Row><Row>11|onlinenews.com.pk|OK|Found|103266|9203|103266|-1|1|82366|5000|4900|3857|62|194|15|111|47|163|7|27|False| | |False| |0|0|0| |ONLINE - International News Network| </Row><Row>12|http://www.online.net|OK|Found|458339|19076|458339|11|3|1|5000|6133|4679|16|19|14|14|7|7|8|8|True|2011-12-18|DownloadedSuccessfully|False| |3|3|27| |Hébergement mutualisé serveurs dédiés - Online.net| </Row><Row>13|online.net|OK|Found|6019818|67627|6019818|-1|1|222450|5000|14134|9284|46|204|30|94|19|121|15|32|False| | |False| |0|0|0| |Hébergement mutualisé serveurs dédiés - Online.net|http://www.online.net</Row><Row>14|http://www.miniclip.com|OK|Found|2789543|55512|2789543|12|3|1|5000|31727|19723|362|17689|40|180|141|937|3|7|True|2011-12-18|HTTP_301_PermanentRedirect|True|DownloadedSuccessfully|0|0|0| | |http://www.miniclip.com/games/en</Row><Row>15|miniclip.com|OK|Found|20615291|169135|20615291|-1|1|6966761|5000|88242|41560|955|68431|163|2236|296|3602|13|23|False| | |False| |0|0|0| | |http://www.miniclip.com/games/en</Row><Row>16|https://webmail.online.nl|OK|Found|4166|161|4166|6|3|1|5000|103|100|0|0|0|0|0|0|0|0|True|2011-12-18|DownloadedSuccessfully|False| |1|4|0| |Veilig en razendsnel internet bij Online| </Row><Row>17|webmail.online.nl|OK|Found|8934|440|8934|-1|2|153|5000|260|239|0|0|0|0|0|0|0|0|False| | |False| |0|0|0| |Veilig en razendsnel internet bij Online|https://webmail.online.nl</Row><Row>18|http://www.fastonlineusers.com|OK|Found|42861832|21195|42861832|11|3|1|5000|9977|6604|62|6544|15|552|15|777|0|0|True|2011-12-18|DownloadedSuccessfully|False| |2|2|6| |Show online Users - Count your online vistis with fastonlineusers| </Row><Row>19|fastonlineusers.com|OK|Found|43224699|21945|43224699|-1|1|34121|5000|10412|6907|79|6813|16|567|16|779|0|0|False| | |False| |0|0|0| |Show online Users - Count your online vistis with fastonlineusers| </Row></DataTable></DataTables></Result>'
      @parsed     =   ::Nokogiri::XML(@xml, nil, "utf-8")
      @response   =   MajesticSeo::Api::ItemInfoResponse.new(@parsed)
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
      @table.row_count.should == 20
    end

    it "should have results for playedonline.com" do
      first_row = @response.items[0]
      
      first_row.url.should                 ==  "http://www.playedonline.com"
      first_row.type.should                ==  :url
      first_row.result_code.should         ==  "OK"
      first_row.success.should             ==  true
      first_row.status.should              ==  "Found"
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
      @parsed     =   ::Nokogiri::XML(@xml, nil, "utf-8")
      @response   =   MajesticSeo::Api::ItemInfoResponse.new(@parsed)
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

    it "should have a data table with the name 'Results' containing 1 row" do
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
  
  #Example XML:
  #<Result Code="OK" ErrorMessage="" FullError="">
  #		<GlobalVars FirstBackLinkDate="2007-03-14" IndexBuildDate="2012-11-05 04:42:33" IndexType="0" MostRecentBackLinkDate="2012-10-14" ServerBuild="2012-11-07 12:42:57" ServerName="PWRGURU" ServerVersion="1.0.4694.22888" UniqueIndexID="20121105044233-HISTORICAL"/>
  #	<DataTables Count="1">
  #		<DataTable Name="Results" RowsCount="1" Headers="ItemNum|Item|ResultCode|Status|ExtBackLinks|RefDomains|AnalysisResUnitsCost|ACRank|ItemType|IndexedURLs|GetTopBackLinksAnalysisResUnitsCost|DownloadBacklinksAnalysisResUnitsCost|RefIPs|RefSubNets|RefDomainsEDU|ExtBackLinksEDU|RefDomainsGOV|ExtBackLinksGOV|RefDomainsEDU_Exact|ExtBackLinksEDU_Exact|RefDomainsGOV_Exact|ExtBackLinksGOV_Exact|CrawledFlag|LastCrawlDate|LastCrawlResult|RedirectFlag|FinalRedirectResult|OutDomainsExternal|OutLinksExternal|OutLinksInternal|LastSeen|Title|RedirectTo|CitationFlow|TrustFlow|TrustMetric">
  #			<Row>0|theconnection.se|OK|Found|117646|8599|117646|-1|1|8592|5000|126238|7119|4659|60|1072|6|38|3|57|0|0|False| | |False| |0|0|0| |&#13;
  #		Nätverk och större möjligheter till frihet. || The Connection.													| |16|4|4</Row>
  #		</DataTable>
  #	</DataTables>
  #</Result>
  describe "response with the title column containing the separator (|) inside" do
    before(:each) do
      #We need to keep the XML on one line - JRuby goes bonanza otherwise
      @xml        =   '<Result Code="OK" ErrorMessage="" FullError=""><GlobalVars FirstBackLinkDate="2007-03-14" IndexBuildDate="2012-11-05 04:42:33" IndexType="0" MostRecentBackLinkDate="2012-10-14" ServerBuild="2012-11-07 12:42:57" ServerName="PWRGURU" ServerVersion="1.0.4694.22888" UniqueIndexID="20121105044233-HISTORICAL"/><DataTables Count="1"><DataTable Name="Results" RowsCount="1" Headers="ItemNum|Item|ResultCode|Status|ExtBackLinks|RefDomains|AnalysisResUnitsCost|ACRank|ItemType|IndexedURLs|GetTopBackLinksAnalysisResUnitsCost|DownloadBacklinksAnalysisResUnitsCost|RefIPs|RefSubNets|RefDomainsEDU|ExtBackLinksEDU|RefDomainsGOV|ExtBackLinksGOV|RefDomainsEDU_Exact|ExtBackLinksEDU_Exact|RefDomainsGOV_Exact|ExtBackLinksGOV_Exact|CrawledFlag|LastCrawlDate|LastCrawlResult|RedirectFlag|FinalRedirectResult|OutDomainsExternal|OutLinksExternal|OutLinksInternal|LastSeen|Title|RedirectTo|CitationFlow|TrustFlow|TrustMetric"><Row>0|theconnection.se|OK|Found|117646|8599|117646|-1|1|8592|5000|126238|7119|4659|60|1072|6|38|3|57|0|0|False| | |False| |0|0|0| |&#13;Nätverk och större möjligheter till frihet. || The Connection.													| |16|4|4</Row></DataTable></DataTables></Result>'
      @parsed     =   ::Nokogiri::XML(@xml, nil, "utf-8")
      @response   =   MajesticSeo::Api::ItemInfoResponse.new(@parsed)
      @table      =   @response.tables["Results"]
    end

    it "should be a valid response" do
      @response.success.should == true
    end

    it "should not have an error message" do
      @response.error_message.should == ""
    end

    it "should have global variables set" do
      @response.global_variables["most_recent_back_link_date"].should == "2012-10-14"
      @response.global_variables["index_type"].should == "0"
    end

    it "should have one returned data table" do
      @response.tables.size.should == 1
    end

    it "should have a data table with the name 'Results'" do
      @table.should_not be_nil
    end

    it "should have a data table with the name 'Results' containing 1 row" do
      @table.row_count.should == 1
    end

    it "should have results for theconnection.se" do
      row                             =   @response.items[0]
      
      row.url.should                  ==  "theconnection.se"
      row.type.should                 ==  :root_domain
      row.result_code.should          ==  "OK"
      row.success.should              ==  true
      row.status.should               ==  "Found"
      row.citation_flow.should        ==  16
      row.trust_flow.should           ==  4
      row.trust_metric.should         ==  4
    end
  end
  
  #Example XML:
  #<Result Code="OK" ErrorMessage="" FullError="">
  #		<GlobalVars FirstBackLinkDate="2007-03-14" IndexBuildDate="2012-11-05 04:42:33" IndexType="0" MostRecentBackLinkDate="2012-10-14" ServerBuild="2012-11-07 12:42:57" ServerName="PWRGURU" ServerVersion="1.0.4694.22888" UniqueIndexID="20121105044233-HISTORICAL"/>
  #	<DataTables Count="1">
  #		<DataTable Name="Results" RowsCount="1" Headers="ItemNum|Item|ResultCode|Status|ExtBackLinks|RefDomains|AnalysisResUnitsCost|ACRank|ItemType|IndexedURLs|GetTopBackLinksAnalysisResUnitsCost|DownloadBacklinksAnalysisResUnitsCost|RefIPs|RefSubNets|RefDomainsEDU|ExtBackLinksEDU|RefDomainsGOV|ExtBackLinksGOV|RefDomainsEDU_Exact|ExtBackLinksEDU_Exact|RefDomainsGOV_Exact|ExtBackLinksGOV_Exact|CrawledFlag|LastCrawlDate|LastCrawlResult|RedirectFlag|FinalRedirectResult|OutDomainsExternal|OutLinksExternal|OutLinksInternal|LastSeen|Title|RedirectTo|CitationFlow|TrustFlow|TrustMetric">
  #			<Row>0|simplygreat.se|OK|Found|1577|31|1577|-1|1|276|5000|25000|29|29|0|0|0|0|0|0|0|0|False| | |False| |0|0|0| |Henrik Nilsson || Designer, Strateg || henrik@simplygreat.se || 0730 - 248 757| |9|3|3</Row>
  #		</DataTable>
  #	</DataTables>
  #</Result>
  describe "response with the title column containing multiple separators (|) inside" do
    before(:each) do
      #We need to keep the XML on one line - JRuby goes bonanza otherwise
      @xml        =   '<Result Code="OK" ErrorMessage="" FullError=""><GlobalVars FirstBackLinkDate="2007-03-14" IndexBuildDate="2012-11-05 04:42:33" IndexType="0" MostRecentBackLinkDate="2012-10-14" ServerBuild="2012-11-07 12:42:57" ServerName="PWRGURU" ServerVersion="1.0.4694.22888" UniqueIndexID="20121105044233-HISTORICAL"/><DataTables Count="1"><DataTable Name="Results" RowsCount="1" Headers="ItemNum|Item|ResultCode|Status|ExtBackLinks|RefDomains|AnalysisResUnitsCost|ACRank|ItemType|IndexedURLs|GetTopBackLinksAnalysisResUnitsCost|DownloadBacklinksAnalysisResUnitsCost|RefIPs|RefSubNets|RefDomainsEDU|ExtBackLinksEDU|RefDomainsGOV|ExtBackLinksGOV|RefDomainsEDU_Exact|ExtBackLinksEDU_Exact|RefDomainsGOV_Exact|ExtBackLinksGOV_Exact|CrawledFlag|LastCrawlDate|LastCrawlResult|RedirectFlag|FinalRedirectResult|OutDomainsExternal|OutLinksExternal|OutLinksInternal|LastSeen|Title|RedirectTo|CitationFlow|TrustFlow|TrustMetric"><Row>0|simplygreat.se|OK|Found|1577|31|1577|-1|1|276|5000|25000|29|29|0|0|0|0|0|0|0|0|False| | |False| |0|0|0| |Henrik Nilsson || Designer, Strateg || henrik@simplygreat.se || 0730 - 248 757| |9|3|3</Row></DataTable></DataTables></Result>'
      @parsed     =   ::Nokogiri::XML(@xml, nil, "utf-8")
      @response   =   MajesticSeo::Api::ItemInfoResponse.new(@parsed)
      @table      =   @response.tables["Results"]
    end

    it "should be a valid response" do
      @response.success.should == true
    end

    it "should not have an error message" do
      @response.error_message.should == ""
    end

    it "should have global variables set" do
      @response.global_variables["most_recent_back_link_date"].should == "2012-10-14"
      @response.global_variables["index_type"].should == "0"
    end

    it "should have one returned data table" do
      @response.tables.size.should == 1
    end

    it "should have a data table with the name 'Results'" do
      @table.should_not be_nil
    end

    it "should have a data table with the name 'Results' containing 1 row" do
      @table.row_count.should == 1
    end

    it "should have results for simplygreat.se" do
      row                             =   @response.items[0]
      
      row.url.should                  ==  "simplygreat.se"
      row.type.should                 ==  :root_domain
      row.result_code.should          ==  "OK"
      row.success.should              ==  true
      row.status.should               ==  "Found"
      row.citation_flow.should        ==  9
      row.trust_flow.should           ==  3
      row.trust_metric.should         ==  3
    end
  end
  
end