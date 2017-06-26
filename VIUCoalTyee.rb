class VIUCoalTyee < SupplejackCommon::Xml::Base
  
  base_url "http://138.197.159.14/data/CoalTyee.xml"

  #we build a file so we can easily isolate this single collection that uses lat/long coordinates instead of Geonames URIs
  
  
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
  
  attribute :title, xpath: "//dc:title"
    
  attributes :category, xpath: "//dc:type" 
  attributes :rights, xpath: "//dc:rights" 

  
  attributes :subject, xpath: "//dc:subject"
  attributes :publisher, xpath: "//dc:publisher", mappings: {
    "Electronic version published by Vancouver Island University" => " Vancouver Island University"

                          }
  

  
    #expected format: "name=Number One; west=123.929004; north=49.157923"
  attribute :locations, xpath: "//dc:coverage" do
    locations = get(:locations).to_a
    locations.collect do |location|
      if location.include? "north="
        lat = /(?<=north\=).*?(?=(\;|\z))/.match(location)[0].to_f
      end
      if location.include? "west="
        lng = /(?<=west\=).*?(?=(\;|\z))/.match(location)[0].to_f * -1
      end
      if location.include? "name="
        name = /(?<=name\=).*?(?=(\;|\z))/.match(location)[0]
      end
      (lat==nil or lng==nil or name==nil) ? next : {lat: lat, lng: lng, name: name}
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