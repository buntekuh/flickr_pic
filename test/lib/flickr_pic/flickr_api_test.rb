require 'minitest/autorun'
require 'flickr_pic'

module FlickrPic
  class FlickrApiTest < Minitest::Test
    UrlRegExp = /https?:\/\/[-_a-zA-Z0-9.\/]+/

    def test_query
      query = ::FlickrPic::FlickrApi.query(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'])
      assert_equal 10, query.size
      for url in query
        assert_match(UrlRegExp, url)
      end
      assert_equal 11, ::FlickrPic::FlickrApi.query(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday', 'January', 'February', 'March', 'April']).size

      assert_equal 10, ::FlickrPic::FlickrApi.query(['sf7w9eqjkd', 'asd708asd', 'asdf8', 'vbn7346h', 'xcvo8', 'fdsgvbc3', 'piewu434']).size

    end

    def test_query_keyword
      # Passing a keyword should return an url to an image
      url = ::FlickrPic::FlickrApi.query_keyword('kitty')
      assert_match(UrlRegExp, url)
      assert FlickrApiTest.remote_file_is_an_image?(url)
    end

    def test_pick_random_word
      assert_match /[a-z]+/, ::FlickrPic::FlickrApi.pick_random_word
    end

    def self.remote_file_is_an_image?(url)
      uri = URI.parse(url)

      Net::HTTP.start(uri.host) do |http|
        res = http.get(uri.path)
        return res['Content-Type'].start_with? 'image'
      end
    end
  end
end