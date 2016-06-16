require 'minitest/autorun'
require 'flickr_pic'

module FlickrPic
  class DownloaderTest < Minitest::Test

    def tmpdir
      dir = Dir.mktmpdir
      begin
        yield dir
      ensure
        FileUtils.remove_entry dir
      end
    end

    def test_download_file
      tmpdir do |dir|
        ::FlickrPic::Downloader.download_file 'https://farm9.staticflickr.com/8346/8210792083_eb16f6f9a7_q.jpg', dir
        assert File.exist?(File.join(dir, '8210792083_eb16f6f9a7_q.jpg'))
      end
    end

    def test_execute
      tmpdir do |dir|
        directory = ::FlickrPic::Downloader.execute ['https://farm9.staticflickr.com/8346/8210792083_eb16f6f9a7_q.jpg', 'https://farm9.staticflickr.com/8866/16715002283_7af3e5956b_q.jpg']
        assert Dir.exist? directory
        assert_equal 2, Dir[File.join(directory, '*')].count
      end 
    end
  end
end