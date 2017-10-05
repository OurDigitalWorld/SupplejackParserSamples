class UBCparser < SupplejackCommon::Json::Base
  
  
  base_url "http://eln-sj4.is.sfu.ca/data/ubcAgain.json"
  
 #we build a json file using the UBC Open Collections API - an awesome experience!
  
  record_selector "$.collection.hits"
  
  attributes :jurisdiction, default: "British Columbia"

   #The jurisdiction field is identified in record_schema.rb. ,to allow us to filter results by region (and create API keys with roles assigned
  # to each jurisdiction. This allows us to create different front ends for different jurisdictions)
 
  attribute :display_content_partner, default: "University of British Columbia"
  attribute :category, path: "$.fields.type"
  attribute :subject, path: "$.fields.subject"
  
  attribute :title , path: "$.fields.title"

  attribute :description, path: "$.fields.description", truncate: 170 do 
    get(:description).mapping("\\"=> '', '"' => '', '[' => '', ']' => '')
    
end

  
  
  
  #BUILD LANGUGE MAPPER
  #converts languages to ISO language codes, and splits into individual literals
  attribute :language, path: "$.fields.language", mappings: {
    "English" => "en",
    "Latin" => "lat",
    "Wakashan languages" => "wak", 
    "Salishan languages" => "sal",
    "Chinook jargon" => "chn", 
    "Athapascan languages" => "ath",
    "Carrier" => "crx", 
    "Ntlakyapamuk" => "thp",
    "French" => "fre",
    "Spanish" => "spa",
    "Nootka" => "nuk",
    "Shuswap" => "shs",
    "Tsimshian" => "tsi",
    "Squawmish" => "squ",
    "Sechelt" => "sec",
    "Lillooet" => "lil",
    "Salish" => "sal",
    "Okanagan" => "oka",
    "Chinook" => "chn",
    "Stalo" => "hur",
    "German" => "ger",
    "Cree" => "cre",
    "Kwakiutl" => "kwk"
    } do
      get(:language).split(";")
    end
   
  
    attribute :display_date, path: "$.fields.dateIssued"
                   
  attribute :publisher, path: "$.fields.publisher"

    
      
    attribute :creator, path: "$.fields.creator" do 
    get(:creator).join(' ; ').mapping(/,\s+\d\d\d\d/ => '', 
      /-\d\d\d\d/ => '', '[' => '', ']' => '', '/' => '', '?' => '')
    
  end
  
  
    attribute :source_url do
    base_url = "https://open.library.ubc.ca/collections/bcbooks/items/"
    object_id = fetch("$._id")
    compose(base_url, object_id)
    end
  
    attribute :thumbnail_url do 
    base_url = "https://oc-mp.library.ubc.ca/img/thumbnails/cdm/bcbooks/200/"
    thumb_id = fetch("$._id")
    compose(base_url, thumb_id)
    end
  
  attributes :landing_url do
    get(:source_url)
  end
  
    attributes :internal_identifier do
    get(:landing_url).downcase
  end
  
  
 
end