require 'flickraw'
require 'config'

module FlickrPic
  # 
  # Queries Flickr against keywords
  # 
  # @author [buntekuh]
  # 
  class FlickrApi
    class FlickrApiException < StandardError; end

    # 
    # Returns a list of urls which link to the best found images on flickr to the given keywords
    # It returns at least 10 images, regardless of how many keywords were passed
    # @param keywords [Array of Strings] Keywords to query Flickr for
    # 
    # @return [Array of URLs] An Array of Urls to Flickr images
    # @raise [FlickrApiException] If connecting to Flickr fails
    def self.query _keywords = []
      keywords = _keywords.clone
      urls = []
      # loop until we have at least 10 images and we have responded to every keyword
      while urls.size < 10 || keywords.size > 0
        word = keywords.shift || pick_random_word
        url = query_keyword word
        urls << url unless url.nil?
      end
      urls
    end

    # 
    # Queries Flickr photos for the top result for the passed keyword
    # @param keyword [String] The keyword to query Flickr for
    # 
    # @return [String] A URI to an image or nil if none was found
    # @raise [FlickrApiException] If connecting to Flickr fails
    def self.query_keyword keyword
      return nil if keyword.empty?
      img = nil

      begin
        img = flickr.photos.search(text: keyword, sort: 'interestingness-desc', media: :photos, per_page: 1).first
      rescue => e
        fail FlickrApiException, e.message
      end
      FlickRaw.url_q img unless img.nil?
    
    end

    # 
    # Picks a random word from a preset list of words
    # because chances are slim that a word in /usr/share/dict/words would return an image from flickr
    # I have instead compiled a list of 100 viable words
    # 
    # @return [String] A word
    def self.pick_random_word
      @@word_file_lines ||= nil

      if @@word_file_lines.nil?
        File.open('config/words.txt') do |file|
          @@word_file_lines = file.readlines()
        end
      end
      
      @@word_file_lines[Random.rand(0...@@word_file_lines.size())]                                                                                                                                                               
    end 
  end
end