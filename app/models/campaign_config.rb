class CampaignConfig

  attr_reader :page, :errors

  def initialize(page)
    @config ||= begin
      until page.part(:campaign_config) or (not page.parent)
        page = page.parent
      end
      string = page.render_part(:campaign_config)
      (string.empty? ? {} : YAML::load(string))
    end
    
    @page, @errors = page, {}
  end
  
  def valid?
    return false if @config['api_key'].blank?
    return false if @config['list_id'].blank?
    return true
  end
  
  def get(key)
    @config[key]
  end
  
end