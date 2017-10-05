class ODWparser2 < SupplejackCommon::Xml::Base

    
  base_url "http://eln-sj4.is.sfu.ca/data/MHGLtemp.xml"
  
  #No OAI for this VITA instance. Walter Lewis at ODW was kind enough to give us an xml file 
  
  attributes :jurisdiction, default: "Ontario"

   #The jurisdiction field is identified in record_schema.rb. ,to allow us to filter results by region (and create API keys with roles assigned
  # to each jurisdiction. This allows us to create different front ends for different jurisdictions)
  
  
  record_selector "//doc" 
  record_format :xml
  
  attributes :display_content_partner, default: "Our Digital World"
  
 
  attributes :title, xpath: "//field[@name='title']"
  
  attributes :subject, xpath: "//field[@name='subject']"
  
  attributes :category, xpath: "//field[@name='type']"
  
  attributes :publisher, xpath: "//field[@name='publisher']"
  
  attributes :display_date, xpath: "//field[@name='dateOldest']"
  
  attribute :creator, xpath: "//field[@name='creator']"
  
  attributes :subject, xpath: "//field[@name='subject']"
  
  attributes :description, xpath: "//field[@name='description']", truncate: 170 do
    get(:description).first
end


  

    
  attribute :locAll do
    fetch("//field[@name='itemLatLong']").mapping( /^/ => "north=", /-/ => " west=")
end


  
  attribute :locations do
  locations = get(:locAll).to_a
   locations.collect do |location|
      if location.include? "north="
        lat = /(?<=north\=).*?(?=(\,|\z))/.match(location)[0].to_f
      end
      if location.include? "west="
        lng = /(?<=west\=).*?(?=(\,|\z))/.match(location)[0].to_f * -1
      end
     # if location.include? "name="
     #   name = /(?<=name\=).*?(?=(\;|\z))/.match(location)[0]
     # end
      (lat==nil or lng==nil) ? next : {lat: lat, lng: lng}
    end
  end

  

  attributes :language, xpath: "//field[@name='language']", mappings: {
    "eng" => "en"

    } 
  
  
  attribute :rights, xpath: "//field[@name='rightsCreativeCommons']", mappings: {
                            "by" => "CC-BY"
                          }
  
  
  attributes :thumbnail_url, xpath: "//field[@name='thumbnail']"
  
  attributes :source_url, xpath: "//field[@name='url']"
  
  attributes :landing_url, xpath: "//field[@name='url']"
    
  attributes :internal_identifier do
    get(:landing_url).downcase
  end
  
  
  
  
end