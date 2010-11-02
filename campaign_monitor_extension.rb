class CampaignMonitorExtension < Radiant::Extension

  version "1.0"
  description "Campaign Monitor extension"
  url "http://github.com/lunaweb/radiant-campaign-monitor-extension"

  def activate
    Page.class_eval do
      include CampaignMonitorTags
    end
#    Page.send :include, CampaignMonitorTags
  end
  
end
