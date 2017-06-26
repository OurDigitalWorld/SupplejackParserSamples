class NorthArch < SupplejackCommon::Xml::Base

  base_url "http://138.197.159.14/data/NorthernArches.xml"

  #UNBC's AtoM instance doesn't allow for EAD over OAI (it's coming in a new release) so we have built an xml file by grepping and wgetting . . . 
  
  record_selector "//ead" 
  record_format :xml
  
  
  attribute :jurisdiction, default: 'British Columbia'

   #The jurisdiction field is identified in record_schema.rb. ,to allow us to filter results by region (and create API keys with roles assigned
  # to each jurisdiction. This allows us to create different front ends for different jurisdictions)
  
  attribute :display_content_partner, default: 'Northern British Columbia Archives'
  
  attributes :title, xpath: "//titleproper"
  
  attributes :language, xpath: "//language", mappings: {'English' =>'en'}
  
  
  attributes :description, xpath: "//scopecontent", truncate: 170
  
  attributes :subject, xpath: "//controlaccess/subject"
  
  attributes :category, default: "photograph"
  
  

  attributes :publisher, xpath: "//publisher"
  
  attributes :display_date, xpath: "//did/unitdate", mappings: {/[a-zA-Z]./ => ''}
  
 
  attribute :creator1, xpath: "//controlaccess/corpname"

  attribute :creator2, xpath: "//did/unittitle1"   
  
  attribute :creator3 do fetch("//note/p").select(:last)
  end
    
  
 attribute :creator do
   compose(get(:creator1), "  ", get(:creator2), "  ", get(:creator3))
end
  
  attributes :rights, xpath: "//userestrict/p"
  
  attribute :source_url, xpath: "//eadid/@url" 
  
  attributes :landing_url, xpath: "//eadid/@url"
    
  attributes :internal_identifier do
    get(:landing_url).downcase
  end
  
  
  attribute :thumbnail_url, xpath: "//dao/@href"  
  
  
end