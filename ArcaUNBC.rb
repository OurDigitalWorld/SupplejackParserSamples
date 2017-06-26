class ArcaUNBC < SupplejackCommon::Oai::Base
  
  
  	base_url "http://unbc.arcabc.ca/oai2"
	
	      # capu, cc cotr, dc, ecuad, jibc, kpu, nwcc, sc, tru, twu, unbc, ufv 
	      
	  

	
	  namespaces mods:"http://www.loc.gov/mods/v3"
	  
	  metadata_prefix "mods"
	  
	#statics
  
  	attribute :publisher, default: "University of Northern British Columbia"

  	attributes :jurisdiction, default: "British Columbia"

  	 #The jurisdiction field is identified in record_schema.rb. ,to allow us to filter results by region (and create API keys with roles assigned
  # to each jurisdiction. This allows us to create different front ends for different jurisdictions)

  
	
  #snippets
	
	
	include_snippet "ArcaMapper"
	
	
	#dynamics
	
	  attributes :title, xpath: "//mods:title"
	  
	  attributes :description, xpath: "//mods:abstract", truncate: 170
	  
	  attributes :format, xpath: "//mods:form"  
  
  
  
  #this doesn't yet address multiple authors
	  
  attributes :familyName, xpath: "//mods:name[mods:role/mods:roleTerm='author']/mods:namePart[@type='family']"
  attributes :givenName, xpath: "//mods:name[mods:role/mods:roleTerm='author']/mods:namePart[@type='given']"
  
  attribute :creator do compose(get(:familyName), ", ", get(:givenName))
  end

  
  	attributes  :display_date, xpath: "//mods:dateIssued"
  

  
  	
	
 
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
    compose("http://unbc.arcabc.ca/islandora/object/", get(:thing3))
end
  
  #---
  
  attribute :source_url do get :landing_url 
  end


  
  
	  attributes :thumbnail_url do
	    compose(get(:landing_url), '/datastream/PREVIEW/view')
	  end
	  
	  attributes :subject, xpath: "//mods:topic"
	  
	  attributes :category, xpath: "//mods:genre"
	  
	  #attributes :publisher, xpath: "//mods:name[mods:role/mods:roleTerm'Degree granting institution']/mods:namePart[1]"
	  
	  attributes :internal_identifier do
	    #for internal_identifier, I've been using the OAI URI when it's available.  But I guess it doesn't really matter, so long as it's unique.
	    get(:landing_url).downcase
	  end
	
	
  
  
  

end