require 'minitest/autorun'
require 'flickr_pic'
require 'flickr_pic/image_cropper'

module FlickrPic
  class FlickrPicTest < Minitest::Test
    def setup
      @plasticUrls = ['https://farm9.staticflickr.com/8346/8210792083_eb16f6f9a7.jpg',
                      'https://farm9.staticflickr.com/8866/16715002283_7af3e5956b.jpg',
                      'https://farm9.staticflickr.com/8401/8785201684_ddbb0f9175.jpg',
                      'https://farm7.staticflickr.com/6090/6053243938_80208302fe.jpg',
                      'https://farm8.staticflickr.com/7470/15648379921_a0d08bc6db.jpg',
                      'https://farm8.staticflickr.com/7510/16307574235_28b4029f51.jpg',
                      'https://farm9.staticflickr.com/8598/16443707755_fd3941cbd5.jpg',
                      'https://farm9.staticflickr.com/8582/16271543379_510a822ac1.jpg',
                      'https://farm6.staticflickr.com/5168/5213389325_dc29476785.jpg',
                      'https://farm8.staticflickr.com/7495/15901587715_a67ba41bd9.jpg']

      @fp = FlickrPic.new 'filename.png', ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
      
      # stubbing FlickrApi.query as it is tested elsewhere
      FlickrApi.stub(:query, @plasticUrls) do
        @fp.query_flickr_api
      end

      @fp.download_results
      @fp.crop_results
    end

    def test_execute
      # FlickrPic.execute 'filename.png', ['a', 'b', 'c']
      # assert File.exist? 'filename.png'
    end

    def test_query_flickr_api
      assert_equal 10,  @fp.urls.size
    end

    def test_download_results
      assert File.directory? @fp.images_dir
      assert_equal 10, Dir[File.join(@fp.images_dir, '*')].count
    end

    def test_crop_results
      assert_equal 10, @fp.images.size
      assert_equal 300, @fp.images.first[:width]
      assert_equal 300, @fp.images.first[:height]
    end
  end
end