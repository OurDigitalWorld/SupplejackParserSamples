class RBCMuseum < SupplejackCommon::Json::Base
 
  
  base_url "http://eln-sj4.is.sfu.ca/data/rbcJson.json"
  
  
  record_selector "$.items"
  
  #NOTE: Supplejack isn't currently able to handle non-incremental page changes
    
  #ID
  attribute :internal_identifier do
    compose("yt:video:", fetch("$.id.videoId"))
  end
  
  #static attributes
  attribute :display_content_partner, default: "Royal British Columbia Museum"
  attributes :jurisdiction, default: "British Columbia"


  attribute :category, default: "Video"
  attribute :publisher, default: "YouTube"
  
  #dynamic attributes
  attribute :title, path: "$.snippet.title"
  attribute :description, path: "$.snippet.description"
  attribute :source_url do
    base_url = "https://www.youtube.com/watch?v="
    video_id = fetch("$.id.videoId")
    compose(base_url, video_id)
  end
  attribute :thumbnail_url, path: "$.snippet.thumbnails.medium.url"
  
#---START ENRICHMENT---
  enrichment :get_song_meta, priority: -4, required_for_active_record: false do
    
    requires :song_url do
      primary[:source_url].mapping(/.*=(.*)/ => 'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=\1&key=AIzaSyDxtV6CVveTXi1yvnwJ6ypmkl2KEeq40_s').first
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
       "Royal BC Museum" => '',
       "Royal British Columbia Museum" => '',
       "Royal British Columbia Museum (Museum)" => '',
       "RBCM" => '', 
       "Episode" => '',
       "Season" => '', 
       "British Columbia" => '',
       "BC" => '',
       "B.C." => '',
       "Webster!" => 'Jack Webster',
       "(Museum)" => '',
       "Museum" => '',
       "Museum (Building Function)" => '',
       "(Building Function)" => '',
       "this week in history" => 'This week in history'
	
	
	
       )
    end

  
    attribute :display_date do
      fetch("$.items[0].snippet.publishedAt").truncate(4, "")
    end
  
  end  
#---END ENRICHMENT---
  

  

end