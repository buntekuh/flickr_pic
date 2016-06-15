module FlickrPic
  class FlickrPicTest < Minitest::Test
    def setup
      @fp = FlickrPic.new 'filename.png', ['a', 'b', 'c']
    end

    def test_execute
      # FlickrPic.execute 'filename.png', ['a', 'b', 'c']
      # assert File.exist? 'filename.png'
    end

    def test_query_flickr_api
      @fp.query_flickr_api
      assert_equal 10,  @fp.urls.size
    end
  end
end