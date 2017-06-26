class VagVimeo2 < SupplejackCommon::Xml::Base
  
  
  base_url "http://138.197.159.14/data/vagVimeo.xml"
  #we build an xml file from the Vimeo RSS feed
  
  record_selector "//item" 
  record_format :xml
  
  
  attribute :jurisdiction, default: 'British Columbia'

   #The jurisdiction field is identified in record_schema.rb. ,to allow us to filter results by region (and create API keys with roles assigned
  # to each jurisdiction. This allows us to create different front ends for different jurisdictions)
  
  attributes :display_content_partner, default: "Vancouver Art Gallery"
  attributes :creator, default: "Vancouver Art Gallery"
  attributes :category, default: "video"
  attributes :language, default: "en"
  attributes :publisher, default: "Vancouver Art Gallery"
  
  
  
  
  attributes :title, xpath: "//title" 
  attributes :description, xpath: "//description", truncate: 170 
  

  attributes :display_date, xpath: "//pubDate" do
    get(:display_date).split(" ").select(4, :last).select(:first, -3)
    
  end
  attributes :thumbnail_url, xpath: "//media-content/media-thumbnail/@url", mappings: {
    "webp" => "webp.jpg"
                        }
  
  attributes :source_url, xpath: "//link" 
  attribute :landing_url, xpath: "//link"

  attributes :internal_identifier do
    get(:landing_url).downcase
  end
  

  
  

end