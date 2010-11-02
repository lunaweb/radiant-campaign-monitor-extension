class CampaignUnsubscribeController < ApplicationController

  skip_before_filter :verify_authenticity_token  

  def create
    @page = Page.find(params[:page_id])
    @page.request, @page.response = request, response
    
    config = CampaignConfig.new(@page)
    camp = Campaign.new(config, params[:campaign])
    @page.last_campaign = config.page.last_campaign = camp
    
    if camp.unsubscribe(params['campaign']['email'])
      redirect_to (config.get('redirect_to') || "#{@page.url}")
    else
      render :text => @page.render
    end
  end
  
#  def direct
#  end
  
end