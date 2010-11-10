#require 'cgi'
#CGI.unescape("Hello+%3Cb%3Ethere%21%3C%2Fb%3E")

ActionController::Routing::Routes.draw do |map|
  
  map.connect '/pages/:page_id/campaign_subscribe', :controller => "campaign", :action => 'subscribe'
  map.connect '/pages/:page_id/campaign_unsubscribe', :controller => "campaign", :action => 'unsubscribe'
  
end