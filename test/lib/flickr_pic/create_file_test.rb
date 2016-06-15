require 'minitest/autorun'
require 'mini_magick'
require 'flickr_pic/create_file'

module FlickrPic
  class CreateFileTest < Minitest::Test
    def test_create
      images = Dir[File.join('test', 'fixtures', 'cropped_images', '*')].collect{|img| MiniMagick::Image.new(img) }
      
      image = CreateFile.create 'image.png', images
      assert File.exist?('image.png')
      FileUtils.rm 'image.png'
      assert image.is_a? MiniMagick::Image

      image = CreateFile.create 'image.jpg', images
      assert File.exist?('image.jpg.png')
      FileUtils.rm 'image.jpg.png'
    end

    def test_closest_square_root
      assert_equal 3, CreateFile.closest_square_root(9)
      assert_equal 4, CreateFile.closest_square_root(10)
      assert_equal 2, CreateFile.closest_square_root(2)
    end
  end
end