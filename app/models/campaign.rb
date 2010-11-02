require 'campaigning'

class Campaign

  attr_reader :config, :data, :errors

  def initialize(config, data)
    @config, @data, @errors = config, data, {}
  end
  
#  100 Invalid API Key
#  103 API Key is empty. This can be the result of an invalid SOAP packet.
#  101 Invalid ListID
  
  def subscribe(email, name = nil)
    @valid = true
    
    if !valid_email?(email)
      @errors[:email] = 'email is invalid'
      @valid = false
    end
    
    if @config.get('api_key').blank?
      @errors[:api_key] = 'api_key is required'
      @valid = false
    end
    
    if @config.get('list_id').blank?
      @errors[:list_id] = 'list_id is required'
      @valid = false
    end
    
    return false unless @valid
    
    begin
      Campaigning::Subscriber.const_set(:CAMPAIGN_MONITOR_API_KEY, @config.get('api_key'))
      subscriber = Campaigning::Subscriber.new(email, name)
      subscriber.add!(@config.get('list_id'))
    rescue RuntimeError => e
      message = e.to_s
      @errors[:subscribe] = message.slice(message.index(' ')+3, message.length)
      @valid = false
    end
  end
  
  def unsubscribe(email)
    @valid = true
    
    if !valid_email?(email)
      @errors[:email] = 'email is invalid'
      @valid = false
    end
    
    if @config.get('api_key').blank?
      @errors[:api_key] = 'api_key is required'
      @valid = false
    end
    
    if @config.get('list_id').blank?
      @errors[:list_id] = 'list_id is required'
      @valid = false
    end
    
    return false unless @valid
    
    begin
      Campaigning::Subscriber.const_set(:CAMPAIGN_MONITOR_API_KEY, @config.get('api_key'))
      Campaigning::Subscriber.unsubscribe!(email, @config.get('list_id'))
    rescue RuntimeError => e
      message = e.to_s
      @errors[:subscribe] = message.slice(message.index(' ')+3, message.length)
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