require 'campaigning'

class Campaign

  attr_reader :config, :data, :errors

  def initialize(config, data)
    @config, @errors = config, {}
    @data = data || {}
  end
  
#  http://www.campaignmonitor.com/api/method/subscriber-add/#returncodes
  def subscribe(email, name = nil)
    @valid = true
    
    if !valid_email?(email)
      @errors[:email] = I18n.t 'email is invalid'
      @valid = false
    end
    
    if @config.get('api_key').blank?
      @errors[:api_key] = I18n.t 'api_key is required'
      @valid = false
    end
    
    if @config.get('list_id').blank?
      @errors[:list_id] = I18n.t 'list_id is required'
      @valid = false
    end
    
    return false unless @valid
    
    begin
      Campaigning::Subscriber.const_set(:CAMPAIGN_MONITOR_API_KEY, @config.get('api_key'))
      
      subscriber = Campaigning::Subscriber.new(email, name)
      raise "201 - The subscriber is already in active list" if subscriber.is_subscribed?(@config.get('list_id'))
      
      subscriber.add!(@config.get('list_id'))
    rescue RuntimeError => e
      code = e.to_s.to_i
      @errors[:subscribe] = I18n.t 'campaign_error_'+code.to_s
#      message = e.to_s
#      @errors[:subscribe] = message.slice(message.index(' ')+3, message.length)
      @valid = false
    end
  end
  
#  http://www.campaignmonitor.com/api/method/subscriber-unsubscribe/#returncodes
  def unsubscribe(email)
    @valid = true
    
    if !valid_email?(email)
      @errors[:email] = I18n.t 'email is invalid'
      @valid = false
    end
    
    if @config.get('api_key').blank?
      @errors[:api_key] = I18n.t 'api_key is required'
      @valid = false
    end
    
    if @config.get('list_id').blank?
      @errors[:list_id] = I18n.t 'list_id is required'
      @valid = false
    end
    
    return false unless @valid
    
    begin
      Campaigning::Subscriber.const_set(:CAMPAIGN_MONITOR_API_KEY, @config.get('api_key'))
      Campaigning::Subscriber.unsubscribe!(email, @config.get('list_id'))
    rescue RuntimeError => e
      code = e.to_s.to_i
      @errors[:subscribe] = I18n.t 'campaign_error_'+code.to_s
#      message = e.to_s
#      @errors[:subscribe] = message.slice(message.index(' ')+3, message.length)
      @valid = false
    end
  end
  
  def valid?
    return @valid
  end
  
  protected

  def valid_email?(email)
    (email.blank? ? false : email =~ /.@.+\../)
  end

end