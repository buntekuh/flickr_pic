require 'minitest/autorun'
require 'mini_magick'
require 'flickr_pic/image_cropper'
require 'config'

module FlickrPic
  class ImageCropperTest < Minitest::Test
    def tmpdir
      dir = Dir.mktmpdir
      FileUtils.cp_r File.join('test', 'fixtures', 'images', '/.'), dir
      begin
        yield dir
      ensure
        FileUtils.remove_entry dir
      end
    end

    def test_crop_images_in_dir
      tmpdir do |dir|
        images = ::FlickrPic::ImageCropper.crop_images_in_dir dir, AppConfig[:sub_image_size], AppConfig[:sub_image_size]
        assert_equal 2, images.size
        assert images.first.is_a? MiniMagick::Image
        assert_equal images.first[:width], AppConfig[:sub_image_size]
        assert_equal images.first[:height], AppConfig[:sub_image_size]
      end
    end

    def test_crop
      tmpdir do |dir|
        image = MiniMagick::Image.open(File.join(dir, 'tree.jpg'))

        refute_equal image[:width], AppConfig[:sub_image_size]
        refute_equal image[:height], AppConfig[:sub_image_size]
  
        ::FlickrPic::ImageCropper.crop image, AppConfig[:sub_image_size], AppConfig[:sub_image_size]
        
        assert_equal image[:width], AppConfig[:sub_image_size]
        assert_equal image[:height], AppConfig[:sub_image_size]
      end
    end
  end
end