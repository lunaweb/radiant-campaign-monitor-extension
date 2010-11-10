class CampaignController < ApplicationController

  skip_before_filter :verify_authenticity_token  

  def subscribe
    @page = Page.find(params[:page_id])
    @page.request, @page.response = request, response
    
    config = CampaignConfig.new(@page)
    camp = Campaign.new(config, params[:campaign])
    @page.last_campaign = config.page.last_campaign = camp
    
    if camp.subscribe(camp.data['email'])
      redirect_to (config.get('subscribe_redirect_to') || "#{@page.url}")
    else
      render :text => @page.render
    end
  end

  def unsubscribe
    @page = Page.find(params[:page_id])
    @page.request, @page.response = request, response
    
    config = CampaignConfig.new(@page)
    camp = Campaign.new(config, params[:campaign])
    @page.last_campaign = config.page.last_campaign = camp
    
    if camp.unsubscribe(camp.data['email'])
      redirect_to (config.get('unsubscribe_redirect_to') || "#{@page.url}")
    else
      render :text => @page.render
    end
  end
  
end