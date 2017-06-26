
class ROMYouTube < SupplejackCommon::Json::Base
  
    base_url "http://138.197.159.14/data/ROM.json"
  
  #NOTE: Supplejack isn't currently able to handle non-incremental page changes, so we built an xml file of ~400 items

  record_selector "$.items"
  
  
    
  #ID
  attribute :internal_identifier do
    compose("yt:video:", fetch("$.id.videoId"))
  end
  
  #static attributes
  attributes :jurisdiction, default: "Ontario"

 #The jurisdiction field is identified in record_schema.rb. ,to allow us to filter results by region (and create API keys with roles assigned
  # to each jurisdiction. This allows us to create different front ends for different jurisdictions)
  
  attribute :display_content_partner, default: "Royal Ontario Museum"
  attribute :category, default: "Video"
  attribute :publisher, default: "YouTube"
  
  #dynamic attributes
  attribute :title, path: "$.snippet.title"
  attribute :description, path: "$.snippet.description", truncate: 170 
  attribute :source_url do
    base_url = "https://www.youtube.com/watch?v="
    video_id = fetch("$.id.videoId")
    compose(base_url, video_id)
  end
  attribute :thumbnail_url, path: "$.snippet.thumbnails.medium.url"
  
#---START ENRICHMENT---
  enrichment :get_song_meta, priority: -4, required_for_active_record: false do
    #add your YouTube api key
    requires :song_url do
      primary[:source_url].mapping(/.*=(.*)/ => 'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=\1&key=YOUR-KEY-HERE').first
    end
         
      url "#{requirements[:song_url]}"
        format :json
  
      attribute :subjectAll do
      fetch("$.items[0].snippet.tags").first
    end
  
  #remove some subjects
     attribute :subject do
     get(:subjectAll).mapping(
       /^\d+$/ => '',
       'Royal Ontario Museum' => ''
  
  
  
       )
    end

  
    attribute :display_date do
      fetch("$.items[0].snippet.publishedAt").truncate(4, "")
    end
  
  end  
#---END ENRICHMENT---
  
  
  
  
  
  

end