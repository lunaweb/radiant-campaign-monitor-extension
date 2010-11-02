module CampaignMonitorTags

  include Radiant::Taggable
  
  def self.included(base)
    base.class_eval { 
      attr_accessor :last_campaign
    }
  end

  tag "campaign" do |tag|
    tag.expand
  end

  desc %{
    Check if las campaign has error

    *Usage*:

    <pre><code><r:if_error>...</r:if_error></code></pre>
  }
  tag "campaign:if_error" do |tag|
    if campaign = tag.locals.page.last_campaign
      if on = tag.attr['on']
        if error = campaign.errors[on]
          tag.locals.error_message = error
          tag.expand
        end
      else
        unless campaign.valid?
          tag.locals.error_message = campaign.errors.collect do |key, value|
            %{<li>#{value}</li>}
          end
          tag.locals.error_message.unshift('<ul>')
          tag.locals.error_message.push('</ul>')
          
          tag.expand
        end
      end
    end
  end

  desc %{
    Display error message

    *Usage*:

    <pre><code><r:if_error><r:if_error:message /></r:if_error></code></pre>
  }
  tag "campaign:if_error:message" do |tag|
    tag.locals.error_message
  end

  desc %{
    Check if las campaign has not error

    *Usage*:

    <pre><code><r:if_success>...</r:if_success></code></pre>
  }
  tag "campaign:if_success" do |tag|
    if campaign = tag.locals.page.last_campaign
      if campaign.valid?
        tag.expand
      end
    end
  end

  desc %{ All campaign-related tags live inside this one. }
  tag "campaign:list" do |tag|
    config = CampaignConfig.new(self)
    if config.valid?
      tag.expand
    else
      "Campaign config is not valid (see Campaign.valid_list_config?)"
    end
  end

  desc %{
    Subscribe to a Campaign Monitor list.
    part "campaign_config" must be defined

    *Usage*:

    <pre><code><r:campaign:list:subscribe /></code></pre>
  }
  tag "campaign:list:subscribe" do |tag|
    action = "/pages/#{tag.locals.page.id}/campaign_subscribe"
    
    results = []
    results << %(<form action="#{action}" method="post" #{campaign_attrs(tag)}>)
    results <<   tag.expand
    results << %(</form>)
  end

  desc %{
    Unsubscribe to a Campaign Monitor list.
    part "campaign_config" must be defined

    *Usage*:

    <pre><code><r:campaign:list:unsubscribe /></code></pre>
  }
  tag "campaign:list:unsubscribe" do |tag|
    action = "/pages/#{tag.locals.page.id}/campaign_unsubscribe"
    
    results = []
    results << %(<form action="#{action}" method="post" #{campaign_attrs(tag)}>)
    results <<   tag.expand
    results << %(</form>)
  end

  tag "campaign:input" do |tag|
    tag.expand
  end

  desc %{
    Generate input for email

    *Usage*:

    <pre><code><r:campaign:input:email /></code></pre>
  }
  tag "campaign:input:email" do |tag|
    tag.attr['name'] = 'email'
    render_tag('campaign:text', tag)
  end
  
  %w(text checkbox hidden radio).each do |type|
    desc %{
      Renders a #{type} input tag for a campaign form. The 'name' attribute is required.
    }
    tag "campaign:#{type}" do |tag|
      raise "'campaign:#{type}' tag requires a 'name' attribute" if tag.attr['name'].blank?
      value = (prior_value(tag) || tag.attr['value'])
      result = [%(<input type="#{type}" value="#{value}" #{campaign_attrs(tag)}>)]
    end
  end

  def prior_value(tag, tag_name=tag.attr['name'])
    if campaign = tag.locals.page.last_campaign
      campaign.data[tag_name]
    else
      nil
    end
  end
  
  def campaign_attrs(tag, extras={})
    attrs = {
      'accept' => nil,
      'accesskey' => nil,
      'alt' => nil,
      'autocomplete' => nil,
      'autofocus' => nil,
      'checked' => nil,
      'class' => nil,
      'contextmenu' => nil,
      'dir' => nil,
      'disabled' => nil,
      'height' => nil,
      'hidden' => nil,
      'id' => tag.attr['name'],
      'lang' => nil,
      'max' => nil,
      'maxlength' => nil,
      'min' => nil,
      'pattern' => nil,
      'placeholder' => nil,
      'size' => nil,
      'spellcheck' => nil,
      'step' => nil,
      'style' => nil,
      'tabindex' => nil,
      'title' => nil,
      'width' => nil}.merge(extras)
    result = attrs.collect do |k,v|
      v = (tag.attr[k] || v)
      next if v.blank?
      %(#{k}="#{v}")
    end.reject{|e| e.blank?}
    result << %(name="campaign[#{tag.attr['name']}]") unless tag.attr['name'].blank?
    result.join(' ')
  end
  
end