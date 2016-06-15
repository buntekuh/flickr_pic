require 'flickr_api'

module FlickrPic
  class FlickrPic
    attr_accessor :filename, :keywords, :urls

    def initialize filename, keywords
      self.filename = filename
      self.keywords = keywords
    end

    def self.execute filename, keywords
      pic = FlickrPic.new
      pic.query_flickr_api
      #download_results
      #crop_results
      #assemble_collage
      #write_to_file
    end

    def query_flickr_api
      self.urls = ::FlickrPic::FlickrApi.query(keywords) 
    end
  end
end