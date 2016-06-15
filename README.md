# FlickrPic

FlickrPic queries the Flickr Api and creates a collage that reflects the given keywords.
The collage is then saved as a png image.

# Usage

call flickr_pic.rb filename list of keywords

e.g.: _flickr_pic.rb 'collage.png' hello kitty_

## Installation

Rename the file config/config.example to config/config.rb and enter your flickr API key and shared secret

$ gem install flick_pic.gem
$ bundle

## Testing

run: 

$ rake test
