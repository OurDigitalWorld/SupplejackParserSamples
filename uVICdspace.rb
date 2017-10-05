class UVicDspace < SupplejackCommon::Oai::Base

  
      
  base_url "http://dspace.library.uvic.ca/oai/request/"
  

  attributes :jurisdiction, default: "British Columbia" 
  
  
  namespaces dc:"http://purl.org/dc/elements/1.1/"
  
  metadata_prefix "oai_dc"
  
  attributes :display_content_partner, default: "University of Victoria"
  attributes :publisher, default: "University of Victoria"

  
  attributes :title, xpath: "//dc:title"

 
  #gets first dc:description field  
  attribute :description, xpath: "//dc:description", truncate: 170 do
    get(:description)
  end


  #attribute :date, xpath: "//dc:date", date: true 

  attribute :display_date, xpath: "//dc:date"  do
    get(:display_date).select(:last)
end
  
  
  attribute :language, xpath: "//dc:language"  do
    get(:language).select(:last)
end
  

  attribute :creator do fetch("//dc:creator").join ' ; '
      end
  
  
 # attribute :language do
   # Dir.glob('*')
  #end
   


  
  #------
  
  attributes :category, xpath: "//dc:type" 
  attributes :rights, xpath: "//dc:rights" 

  
  attributes :subject, xpath: "//dc:subject"
 
  
  

  

  attribute :landing_url, xpath: '//dc:identifier' do
    get(:landing_url).find_with('hdl.handle.net')
  end
  

	#attribute :landing_url do fetch("//header/identifier").mapping('oai:viuspace.viu.ca:' => 'http://hdl.handle.net/')
  #end
  
  attributes :source_url do
   get(:landing_url)
	end
  
  attributes :internal_identifier do
    get(:landing_url).downcase
	end
  
  
  attribute :thumbnail_url, default: "https://dspace.library.uvic.ca/themes/Mirage/images/pdf.png"

  
  #sequence=5 becomes sequence=7 for the thumbs display

 #attribute :thumbnail_url, xpath: '//dc:identifier' do
  # get(:thumbnail_url).find_with('sequence').mapping('sequence=5' => 'sequence=7')
  #end
  end
  
  