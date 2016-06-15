require 'minitest/autorun'
require 'mini_magick'
require 'flickr_pic/image_cropper'

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
        images = ::FlickrPic::ImageCropper.crop_images_in_dir dir, 300, 300
        assert_equal 2, images.size
        assert images.first.is_a? MiniMagick::Image
        assert_equal images.first[:width], 300
        assert_equal images.first[:height], 300
      end
    end

    def test_crop
      tmpdir do |dir|
        image = MiniMagick::Image.open(File.join(dir, 'tree.jpg'))

        refute_equal image[:width], 300
        refute_equal image[:height], 300

        ::FlickrPic::ImageCropper.crop image, 300, 300
        
        assert_equal image[:width], 300
        assert_equal image[:height], 300
      end
    end
  end
end