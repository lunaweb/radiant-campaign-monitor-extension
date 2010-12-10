Campaign Monitor
================

---

Installation
------------

git clone git://github.com/lunaweb/radiant-campaign-monitor-extension.git vendor/extensions/campaign_monitor

---

Utilisation
-----------

les tags <code>&lt;r:campaign:list:subscribe&gt;</code> et <code>&lt;r:campaign:list:unsubscribe&gt;</code> génèrent un <code>&lt;form&gt;...&lt;/form&gt;</code>

inscription

	<r:campaign:list:subscribe>...</r:campaign:list:subscribe>
	
désinscription

	<r:campaign:list:unsubscribe>...</r:campaign:list:unsubscribe>

générer le champ email

	<r:campaign:input:email />

---

Configuration
-------------

définir une part "campaign_config"

	api_key: xxx
	list_id: xxx
	subscribe_redirect_to: /newsletter/confirmation-inscription/
	unsubscribe_redirect_to: /newsletter/confirmation-desinscription/
	
* api_key : clef développeur disponible dans "Account Settings > API Key"
* list_id : identifiant de la liste disponible dans "[client] > Lists & Subscribers > [liste] > (change name/type) > API Subscriber List ID"
* subscribe\_redirect\_to : url de la page en cas de succès d'inscription
* unsubscribe\_redirect\_to : url de la page en cas de succès de désinscription

---