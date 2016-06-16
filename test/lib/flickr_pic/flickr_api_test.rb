require 'minitest/autorun'
require 'flickr_pic'
require 'config'

module FlickrPic
  class QueryFlickrTest < Minitest::Test
    UrlRegExp = /https?:\/\/[-_a-zA-Z0-9.\/]+/

    def test_execute
      query = ::FlickrPic::QueryFlickr.execute(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'])
      assert_equal AppConfig[:min_number_of_images], query.size
      for url in query
        assert_match(UrlRegExp, url)
      end
      assert_equal 11, ::FlickrPic::QueryFlickr.execute(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday', 'January', 'February', 'March', 'April']).size

      assert_equal AppConfig[:min_number_of_images], ::FlickrPic::QueryFlickr.execute(['sf7w9eqjkd', 'asd708asd', 'asdf8', 'vbn7346h', 'xcvo8', 'fdsgvbc3', 'piewu434']).size

    end

    def test_query_keyword
      # Passing a keyword should return an url to an image
      url = ::FlickrPic::QueryFlickr.query_keyword('kitty')
      assert_match(UrlRegExp, url)
      assert QueryFlickrTest.remote_file_is_an_image?(url)
    end

    def test_pick_random_word
      assert_match /[a-z]+/, ::FlickrPic::QueryFlickr.pick_random_word
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