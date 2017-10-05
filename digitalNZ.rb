class DigitalNZ < SupplejackCommon::Json::Base

  

  
  base_url "http://api.digitalnz.org/v3/records.json?api_key=YOUR-KEY-HERE&fields=title,display_content_partner,creator,landing_url,source_url,thumbnail_url,subject,rights,category,description,id,date,publisher,language,locations&geo_bbox=-41,174,-42,175&text=horse"
  

  record_selector "$.search.results"

  attribute :display_content_partner, default: "South Pacific Surprise!"
  attribute :category, path: "$.category"
  attribute :publisher, path: "$.publisher"
  attribute :subject, path: "$.subject"
  attribute :language, path: "$.language"

  attribute :title, path: "$.title"
  attribute :description, path: "$.description", truncate: 170

  attribute :source_url, path: "$.source_url"
  attribute :landing_url, path: "$.landing_url"
  attribute :thumbnail_url, path: "$.thumbnail_url"
  attribute :internal_identifier do get(:landing_url).downcase
	end
  attribute :display_date, path: "$.date", truncate: {length: 4, omission: ""}
  
   
  
 attribute :locations, path: "$.locations"


  
  
  
  
  
  
  
end