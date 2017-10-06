
#vanpunk-1_collection

class SFULibrary < SupplejackCommon::Xml::Base

  
 base_url "http://eln-sj4.is.sfu.ca/data/sfu2.xml"

 namespaces dc:"http://purl.org/dc/elements/1.1/"
  
 record_selector "//record"

  
 record_format :xml


  
  attribute :jurisdiction, default: "British Columbia" 
  
  
  attribute :display_content_partner, default: "Simon Fraser University" 
  attributes :title, xpath: "//dc:title"
  
  
  
 
  #gets first dc:description field  
  attribute :description, xpath: "//dc:description", truncate: 170


  attribute :extent, xpath: "//dc:format" do
    get(:extent).first
  end
  


  attribute :display_date, xpath: "//dc:date", truncate: {length: 4, omission: ""}

 

  
  attribute :creator, xpath: "//dc:creator" do 
    get(:creator).join(' ; ')
    
  end


  
  attributes :language, xpath: "//dc:language"
  
  attributes :rights, xpath: "//dc:rights"

  
  
  attributes :category, xpath: "//dc:type" 
  attributes :rights, xpath: "//dc:rights" 
  attributes :ID1, xpath: "//dc:identifier" do
    get(:ID1).select(:first)
end
  
  attributes :subject, default: "Punk rock music--British Columbia" 

  
attribute :landing_url do
  compose("http://digital.lib.sfu.ca/islandora/object/", get(:ID1))
end
  
  
  attributes :source_url do
    get(:landing_url)
  end

  attribute :thumbnail_url do
  
    front = "http://digital.lib.sfu.ca/islandora/object/"
    tail = "/datastream/JPG/view"
    mid = get(:ID1)
    
     compose(front,mid,tail)
  end
  
  


  attributes :internal_identifier do
    get(:landing_url).downcase
   
  end
  


  
  

  
  
  
  
  
  
end