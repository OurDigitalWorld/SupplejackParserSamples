base_url "http://YOUR-REPO-HERE.arcabc.ca/oai2"

      # capu, cc cotr, dc, ecuad, jibc, kpu, nwcc, sc, tru, twu, unbc, ufv 
     
  
#statics

  namespaces mods:"http://www.loc.gov/mods/v3"
  
  metadata_prefix "mods"
  
  

#snippits


include_snippet "ArcaMapper"


#dynamics

  attributes :title, xpath: "//mods:title"
  
  attributes :description, xpath: "//mods:abstract", truncate: 170
  
  attributes :format, xpath: "//mods:form"  
  
  attributes :creator, xpath: "//mods:name[mods:role/mods:roleTerm='author']/mods:namePart", join: " "

  attributes :landing_url, xpath: "//mods:url"
  
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
