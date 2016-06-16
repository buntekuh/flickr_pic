require 'query_flickr'
require 'downloader'
require 'image_cropper'
require 'create_file'

module FlickrPic
  # 
  # Command that:
  # - accepts a list of search keywords as arguments
  # - queries the Flickr API for the top-rated image for each keyword
  # - downloads the results
  # - crops them rectangularly
  # - assembles a collage grid from nine images and
  # - writes the result to a user-supplied filename
  # 
  # @author [buntekuh]
  # 
  class FlickrPic
    attr_accessor :filename, :keywords, :urls, :images_dir, :images

    def initialize filename, keywords
      self.filename = filename
      self.keywords = keywords
    end

    # 
    # Main entry point to the application
    # does everything :)
    # @param filename [String] The file the final image should be saved as
    # @param keywords [Array of Strings] The keywords to query Flickr for
    # 
    # @return [MiniMagick::Image] The final image
    #
    # @raise [QueryFlickr::QueryFlickrException] If connecting to Flickr fails
    # @raise [Downloader::DownloadException] If a file could not be downloaded or written
    def self.execute filename, keywords
      pic = FlickrPic.new filename, keywords
      pic.query_flickr
      pic.download
      pic.crop_images
      pic.create_file
    end

    # 
    # Queries Flickr for the images
    # The urls are stored in the urls attribute
    # 
    # @raise [QueryFlickr::QueryFlickrException] If connecting to Flickr fails
    def query_flickr
      self.urls = ::FlickrPic::QueryFlickr.execute(keywords) 
    end

    # 
    # Downloads the images from the internet and saves them into a directory
    # The directory is stored in the dir attribute
    # 
    # @raise [Downloader::DownloadException] If a file could not be downloaded or written
    def download
      self.images_dir = ::FlickrPic::Downloader.execute urls
    end

    # 
    # Crops the downloaded images
    #
    def crop_images
      self.images = ::FlickrPic::ImageCropper.execute images_dir, AppConfig[:sub_image_size], AppConfig[:sub_image_size]
    end

    # 
    # Creates the final file as a png
    # and renders the cropped images onto it
    # @raise [CreateFile::FileWriteError] If the file could not be created
    # 
    def create_file
      ::FlickrPic::CreateFile.execute filename, images
    end
  end
end