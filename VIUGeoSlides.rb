
class VIUGeoSlides < SupplejackCommon::Xml::Base
  
  
  base_url "http://eln-sj4.is.sfu.ca/data/440.xml"

  #we build a file so we can easily isolate this collection that uses Geonames URIs instead of lat/long coordinates

  namespaces dc:"http://purl.org/dc/elements/1.1/"
  
  record_selector "//record"

  
  record_format :xml
  
   
  attribute :display_content_partner, default: "Vancouver Island University" 
  
  
  attribute :landing_url do fetch("//header/identifier").mapping('oai:viuspace.viu.ca:' => 'http://hdl.handle.net/')
  end

  
  attributes :jurisdiction, default: "British Columbia"
   #The jurisdiction field is identified in record_schema.rb. ,to allow us to filter results by region (and create API keys with roles assigned
  # to each jurisdiction. This allows us to create different front ends for different jurisdictions)
  
  
  attributes :source_url do
   get(:landing_url)
  end
  
  attributes :internal_identifier do
    get(:landing_url).downcase
  end
  
  
  
    attribute :description, xpath: "//dc:description", truncate: 170 do
    get(:description).first
  end

  attribute :extent, xpath: "//dc:format" do
    get(:extent).first
  end


  attribute :display_date, xpath: "//dc:date"  do
    get(:display_date).select(:last)
end
  

  attribute :creator do fetch("//dc:creator").join ' ; '
    
    end
  
   
    
  attributes :category, xpath: "//dc:type" 
  attributes :rights, xpath: "//dc:rights" 
  attributes :landing_url, xpath: "//dc:identifier" do
    get(:landing_url).select(:last)
end
  
  attributes :subject, xpath: "//dc:subject"
  attributes :publisher, xpath: "//dc:publisher", mappings: {
    "Electronic version published by Vancouver Island University" => " Vancouver Island University"

                          }
  
  
  
  
  
  
  
  
  attribute :title, xpath: "//dc:title"
  
  attribute :coverage, xpath: "//dc:coverage"
  
  attribute :locations do
    splits = get(:coverage).split(',').select(:last)
    geoID = splits.split('/').select(:last)
    
    front = "http://ws.geonames.org/get?geonameId="
    tail = "&style=full&username=siftond"
    mid = geoID
    
    compose(front,mid,tail)
  end
  
  enrichment :get_lat_meta, priority: -4, required_for_active_record: false do 
    
      requires :uri do
        primary[:locations].first
    end
    
    url requirements[:uri]
    format :xml
    
  attribute :locations do
    [
      {lat: fetch("//geoname/lat").first, 
        lng: fetch("//geoname/lng").first}
        #geonamesId: fetch("//geoname/geonameId").first}
    ]
  end
 
end
  
  
  
  
  attribute :thumbnail_url do 
    output = fetch('//dc:description').find_with('.pdf').presence ||
      fetch('//dc:identifier').find_with('.jpg')
    output = output.split("?").first 

  unless output.include? '.jpg.jpg'
    output = compose(output, ".jpg")
  end 

  output
end   
  
    
  
end