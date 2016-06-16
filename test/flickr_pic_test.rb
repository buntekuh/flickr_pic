require 'minitest/autorun'

class FlickrPicTest < Minitest::Test
    def test_commandline
      filename = 'filename.png'
      FileUtils.rm filename rescue nil
      `./flickr_pic.rb #{filename} Monday Tuesday Wednesday Thursday Friday Saturday Sunday January April Juli October America Europe Asia Africa Australia`
      assert File.exist? filename
      FileUtils.rm filename
    end
  end