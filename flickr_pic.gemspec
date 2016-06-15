lib = File.expand_path('../lib/flickr_pic', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.summary = 'FlickrPic queries the Flickr Api and creates a collage that reflects the given keywords'
  s.name = 'flickrPic'
  s.author = 'Bernd Eickhoff'
  s.email =  'beickhoff01@gmail.com'
  s.license = 'LGPL'
  s.version = 0.1
  s.files = Dir['lib/**/*'] + Dir['config/*.rb'] + %w{flickr_pic.rb LICENCE README.md rakefile Gemfile Gemfile.lock}
  s.require_paths = ['lib', 'lib/flickr_pic', 'config']
  s.add_runtime_dependency 'flickraw'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'
end