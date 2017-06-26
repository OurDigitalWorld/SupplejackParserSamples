

class BrockOai < SupplejackCommon::Oai::Base
  
    
  base_url "http://dr.library.brocku.ca/oai/request"
  
  namespaces mets: "http://www.loc.gov/METS/",
               dc: "http://purl.org/dc/elements/1.1/",
            xlink: "http://www.w3.org/TR/xlink/",
              dim: "http://www.dspace.org/xmlns/dspace/dim/"

  
  attribute :jurisdiction, default: "Ontario"
   #The jurisdiction field is identified in record_schema.rb. ,to allow us to filter results by region (and create API keys with roles assigned
  # to each jurisdiction. This allows us to create different front ends for different jurisdictions)
  
  attribute :internal_identifier, xpath: '//record/header/identifier'
  attribute :display_content_partner, default: 'Brock University' #change to match new source

  attribute :title, xpath: '//dc:title'
  attribute :description, xpath: '//dc:description'
  attribute :creator, xpath: '//dc:creator'
  attribute :subject, xpath: '//dc:subject', mappings: {
    'Harvested from' => ''

                          }
  
  attribute :display_date do fetch('//dc:date').truncate(4, "").select(:last) #changed to match 4 digit standard
    end
  
  attribute :category, xpath: '//dc:type', mappings: {'Doctoral Thesis' => 'Dissertation/thesis'}

  attribute :language, xpath: '//dc:language'
  attribute :rights, xpath: '//dc:rights'
  attribute :publisher, xpath: '//dc:publisher'
  
  attribute :source_url, xpath: '//dc:identifier' do
    get(:source_url).find_with('hdl.handle.net')
  end
  
  enrichment :get_thumbnail, priority: -4, required_for_active_record: false do
    
    requires :uri do
      primary[:source_url].mapping(/^.*handle\.net(.*)$/ => 'http://dr.library.brocku.ca/metadata/handle\1/mets.xml').first
    end

    #for testing
    #attribute :subject, default: "#{requirements[:uri]}"
 
    url requirements[:uri]
    format :xml
    
  attribute :thumbnail_url, xpath: '//*[@USE="THUMBNAIL"]//@*[local-name()="href"]' do
    compose('http://dr.library.brocku.ca', get(:thumbnail_url))
  end
    
  end
  
  
  
  


end