class ArcaECUAD < SupplejackCommon::Oai::Base


  
  base_url "http://ecuad.arcabc.ca/oai2"
  
        # capu, cc cotr, dc, ecuad, jibc, kpu, nwcc, sc, tru, twu, unbc, ufv 
        
  attributes :jurisdiction, default: "British Columbia" 

  #The jurisdiction field is identified in record_schema.rb. ,to allow us to filter results by region (and create API keys with roles assigned
  # to each jurisdiction. This allows us to create different front ends for different jurisdictions)

  
  namespaces dc:"http://purl.org/dc/elements/1.1/"
    
  metadata_prefix "oai_dc"
    
  #statics
  
  attribute :display_content_partner, default: "Emily Carr University of Art and Design"
  
  attribute :publisher, default: "Emily Carr University of Art and Design"

  
  attribute :category, default: "photograph"
  

  
  #dynamics
  
  attributes :title, xpath: "//dc:title"
    
  attribute :creator do fetch("//dc:creator").join ' ; '
    
    end
  
    #gets first dc:description field  
  attribute :description, xpath: "//dc:description", truncate: 170# do
    #get(:description).mapping('"' => '')
  #end



  attribute :display_date, xpath: "//dc:date"  do
    get(:display_date).truncate(4, "")
end
  




  #filter out for photo/wosk
  
  attributes  :setSpec do fetch("//setSpec")
  end
  
 reject_if do
   get(:setSpec).find_with(/cals/).present? or
   get(:setSpec).find_with(/gradshow/).present?  or  
   get(:setSpec).find_with(/theses/).present? or
   get(:setSpec).find_with(/studentpubs/).present? or
   get(:setSpec).find_with(/wosk/).present? 
  end
 
  #A not very sophisticated way to create our landing_url (it's not in the record)

  attribute :thing do fetch("//identifier").split(":")
end

  attribute :thing2 do
  get(:thing).select(:last)
end
  
  
  

  attribute :thing3 do
  get(:thing2).mapping(/_/ => '%3A')
end

  attribute :landing_url do
    compose("http://ecuad.arcabc.ca/islandora/object/", get(:thing3))
end
  
  #---
  
  attribute :source_url do get :landing_url 
  end


  
  
    attributes :thumbnail_url do
      compose(get(:landing_url), '/datastream/TN/view')
    end
    
  

  attributes :subject, xpath: "//dc:subject"
    
  
    
   
    attributes :internal_identifier do
      #for internal_identifier, I've been using the OAI URI when it's available.  But I guess it doesn't really matter, so long as it's unique.
      get(:landing_url).downcase
    end
  
  
  
  

  
  
  
  
end