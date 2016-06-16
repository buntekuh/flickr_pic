# FlickrPic

A Commandline Application that:

-   accepts a list of search keywords as arguments
-   queries the Flickr API for the top-rated image for each keyword
-   downloads the results
-   crops them rectangularly
-   assembles a collage grid from at least ten images
-   writes the result to a user-supplied filename

FlickrPic queries the Flickr Api and creates a collage that reflects the given keywords.
The collage is then saved as a png image.


## Usage

call 
$ _flickr_pic.rb filename list of keywords_

e.g.: 
$ _flickr_pic.rb image.png Monday Tuesday Wednesday Thursday Friday Saturday Sunday January April Juli October America Europe Asia Africa Australia_


## Installation

$ _gem install flick_pic.gem_


## Testing

run: 

$ _rake test_

## Please note

I have created a Flickr account necessary for querying the Flickr API.
I may delete this account in the future.
If so, please create your own Flickr account, create API keys and enter them in _config/config.rb_.
