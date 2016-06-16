require 'minitest/autorun'
require 'mini_magick'
require 'flickr_pic/create_file'

module FlickrPic
  class CreateFileTest < Minitest::Test
    def instantiate
      begin
        yield CreateFile.new('image.png', @images)
      ensure
        FileUtils.rm 'image.png'
      end
    end

    def setup
      @images = images = Dir[File.join('test', 'fixtures', 'cropped_images', '*')].collect{|img| MiniMagick::Image.new(img) }
    end

    def test_execute
      @image = CreateFile.execute 'image.png', @images
      assert File.exist?('image.png')
      FileUtils.rm 'image.png'
      assert @image.is_a? MiniMagick::Image

      image = CreateFile.execute 'image.jpg', @images
      assert File.exist?('image.jpg.png')
      FileUtils.rm 'image.jpg.png'
    end

    def test_make_collage
      # without diving into minimagick all I can test is wether the file has in fact changed
      require 'digest/md5'
      instantiate do |create_file|
        old_digest = Digest::MD5.hexdigest(File.read('image.png'))
        create_file.make_collage
        new_digest = Digest::MD5.hexdigest(File.read('image.png'))
        refute_equal old_digest, new_digest
      end
    end

    def test_column_row
      instantiate do |create_file|
        create_file.items_per_side = 3
        assert_equal [0,0], create_file.send(:column_row, 0)
        assert_equal [1,0], create_file.send(:column_row, 1)
        assert_equal [0,1], create_file.send(:column_row, 3)
        assert_equal [2,2], create_file.send(:column_row, 8)
      end
    end

    def test_compose
      # no idea how to test it
      # i would mostly be testing mini magick so i'll take a pass on this one
    end

    def test_file_writable?
      instantiate do |create_file|
        assert create_file.send('file_writable?')
        create_file.filename = '/../../hallo.png'
        assert_raises ::FlickrPic::CreateFile::FileWriteError do
          create_file.send('file_writable?')
        end
      end
    end

    def test_closest_square_root
      instantiate do |create_file|
        assert_equal 3, (create_file.send :closest_square_root, 9)
        assert_equal 4, (create_file.send :closest_square_root, 10)
        assert_equal 2, (create_file.send :closest_square_root, 2)
      end
    end
  end
end