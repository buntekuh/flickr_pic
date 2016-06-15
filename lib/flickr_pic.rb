require 'flickr_api'
require 'downloader'

module FlickrPic
  class FlickrPic
    attr_accessor :filename, :keywords, :urls, :images_dir

    def initialize filename, keywords
      self.filename = filename
      self.keywords = keywords
    end

    # 
    # Main entry point to the application
    # does everything : )
    # @param filename [String] The file the final image should be saved as
    # @param keywords [Array of Strings] The keywords to query Flickr for
    # 
    # @return [type] [description]
    #
    # @raise [FlickrApi::FlickrApiException] If connecting to Flickr fails
    # @raise [Downloader::DownloadException] If a file could not be downloaded or written
    def self.execute filename, keywords
      pic = FlickrPic.new filename, keywords
      pic.query_flickr_api
      pic.download_results
      pic.crop_results
      pic.assemble_collage
      pic.write_to_file
    end

    # 
    # Queries Flickr for the images
    # The urls are stored in the urls attribute
    # 
    # @raise [FlickrApi::FlickrApiException] If connecting to Flickr fails
    def query_flickr_api
      self.urls = ::FlickrPic::FlickrApi.query(keywords) 
    end

    # 
    # Downloads the images from the internet and saves them into a directory
    # The directory is stored in the dir attribute
    # 
    # @raise [Downloader::DownloadException] If a file could not be downloaded or written
    def download_results
      self.images_dir = ::FlickrPic::Downloader.get urls
    end

    def crop_results
      # TODO
    end

    def assemble_collage
      # TODO
    end

    def write_to_file
      # TODO
    end

  end
end