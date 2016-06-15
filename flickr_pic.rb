#!/usr/bin/env ruby


# we need at least 2 parameters
# if we get less print usage info and exit
if ARGV.size < 2
  puts "flickr_pic queries the Flickr Api and creates a collage that reflects the given keywords"
  puts "usage: flick_pic.rb filename list of keywords"
  exit 1
end

filename = ARGV.shift
keywords = ARGV

require './lib/flickr_pic.rb'

begin
  FlickrPic::FlickrPic.execute filename, keywords
rescue => e
  puts '####### An Exception occured #######'
  puts e.message
  exit 1
end

