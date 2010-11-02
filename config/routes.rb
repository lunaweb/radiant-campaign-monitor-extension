require 'cgi'
#CGI.unescape("Hello+%3Cb%3Ethere%21%3C%2Fb%3E")

ActionController::Routing::Routes.draw do |map|
  
  map.resources 'campaign_subscribe', :path_prefix => "/pages/:page_id", :controller => "campaignSubscribe"
  map.resources 'campaign_unsubscribe', :path_prefix => "/pages/:page_id", :controller => "campaignUnsubscribe"
#  map.connect 'campaign_unsubscribe/:email', :controller => 'campaignUnsubscribe', :action => 'direct'
  
end