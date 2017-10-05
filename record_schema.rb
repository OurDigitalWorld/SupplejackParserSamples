# The majority of the Supplejack API code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3.
# One component is a third party component. See https://github.com/DigitalNZ/supplejack_api for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and
# the Department of Internal Affairs. http://digitalnz.org/supplejack
class RecordSchema
  include SupplejackApi::SupplejackSchema

  # Namespaces
  namespace :dc,        url: 'http://purl.org/dc/elements/1.1/'
  namespace :sj,        url: ''

  # Fields
  string    :record_id,                   store: false,                                           namespace: :sj
  string    :concept_ids,                                                                         namespace: :sj
  string    :title,                       search_boost: 10,     search_as: [:filter, :fulltext],  namespace: :dc
  string    :description,                 search_boost: 2,      search_as: [:filter, :fulltext],  namespace: :dc
        
  string    :display_content_partner,                           search_as: [:filter, :fulltext],  namespace: :sj
  string    :display_collection,                                search_as: [:filter, :fulltext],  namespace: :sj
  string    :source_url,                                                                          namespace: :sj
  string    :thumbnail_url,                                                                       namespace: :sj
  string    :subject,                     multi_value: true,    search_as: [:filter],             namespace: :dc
  string    :display_date,                                                                        namespace: :sj
  string    :creator,                     multi_value: true,                                      namespace: :dc
  string    :category,                    multi_value: true,    search_as: [:filter],             namespace: :sj

  # Custom fields
  string    :language,               multi_value: true,    search_as: [:filter],             namespace: :dc
  string    :rights,                          search_as: [:filter],          namespace: :dc
  string    :publisher,                        search_as: [:filter],              namespace: :dc
  string    :jurisdiction,                      multi_value: true,    search_as: [:filter, :fulltext],          namespace: :sj


  string :locations, multi_value: true
 
  latlon(:lat_lng) do
        search_as [:filter]
        multi_value true
        search_value do |record|
          puts record.title
          #if record.locations.is_a?(Object) do
          #only record coordinates for locations with lat / lng present
      #record.locations.select{|l| l[:lat].present? and l[:lng].present?}.collect do |l|
      record.locations.reject{|l| l.is_a? (String)}.select{|l| l[:lat].present? and l[:lng].present?}.collect do |l|
        #convert lat/lng to floating point to ensure coordinates only recieve numeric input
            lat = l[:lat].to_f
        lng = l[:lng].to_f
            #puts 'coordinate:' + Sunspot::Util::Coordinates.new(lat,lng).to_s
        Sunspot::Util::Coordinates.new(lat,lng)
      #end
       # end
  end
end
end
  # Groups
  group :locations do
    fields [:locations]
  end

  group :core do
    fields [:record_id]
  end

  group :default do
    includes [:core]
    fields [
      :title,
      :description,
      :creator,
      :thumbnail_url,
      :locations,
      :jurisdiction
    ]
  end

  group :all do
    includes [:default]
    fields [
      :concept_ids,
      :subject,
      :display_content_partner,
      :display_collection,
      :source_url,
      :thumbnail_url,
      :display_date,
      :creator,
      :category,
      :language,
      :rights,
      :publisher
    ]
  end

   # Roles
jurisdictions = ['British Columbia', 'Ontario']

role :bc do
  record_restrictions({
    jurisdiction: jurisdictions.-(['British Columbia']) 
  })
end


role :on do
  record_restrictions({
    jurisdiction: jurisdictions.-(['Ontario']) 
  })
end



  role :developer do
    default true
  end
  role :admin

  mongo_index :source_url,         fields: [{source_url: 1}]

end