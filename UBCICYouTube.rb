class UBCICYouTube < SupplejackCommon::Json::Base
  
  
  
      base_url "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UC-RRZHXSHyYiIP8RLHSKlWw&key=YOUR-KEY-HERE&maxResults=50"
  record_selector "$.items"
  
  #NOTE: Supplejack isn't currently able to handle non-incremental page changes
    
  
  attributes :jurisdiction, default: "British Columbia"
  #ID
  attribute :internal_identifier do
    compose("yt:video:", fetch("$.id.videoId"))
  end
  
  #static attributes
  attribute :display_content_partner, default: "Union of BC Indian Chiefs"
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
      primary[:source_url].mapping(/.*=(.*)/ => 'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=\1&key=YOUR-KEY-HERE').first
    end
         
      url "#{requirements[:song_url]}"
        format :json
  
      attribute :subjectAll do
      fetch("$.items[0].snippet.tags").first
    end
  
  #remove numerical subjects
   attribute :subject do
     get(:subjectAll).mapping(
       /^\d+$/ => '',
       "Union of BC Indian Chiefs" => '',
       "Union of B.C. Indian Chiefs" => '' 
       )
    end
  
    attribute :display_date do
      fetch("$.items[0].snippet.publishedAt").truncate(4, "")
    end
  
  end  
#---END ENRICHMENT---
  
  
  

end