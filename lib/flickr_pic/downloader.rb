module FlickrPic
  class Downloader
    # 
    # Downloads the selected images
    # 
    # @author [buntekuh]
    # 
    class DownloadException < StandardError; end
    
    # 
    # Downloads files from a list of urls
    # @param urls [Array of Strings] The urls files should be downloaded from
    # 
    # @return [String] The directory the files were saved to
    # @raise [DownloadException] If a file could not be downloaded or written
    def self.execute urls
      # the image directory is retained as per specs
      # in a clean environment the directory should be destroyed
      # tmp dirs are automatically destroyed by the os
      directory = Dir.mktmpdir
      
      for url in urls
        download_file url, directory
      end

      directory
    end

    # 
    # Downloads a single file and saves it to the given directory
    # @param url [String] The url to load the file from
    # @param directory [String] The directory to save the file to
    # 
    # @return nothing
    # @raise [DownloadException] If a file could not be downloaded or written
    def self.download_file url, directory
      uri = URI.parse url
      filename = File.join directory, File.basename(uri.path)
      begin
        Net::HTTP.start(uri.host) do |http|
          res = http.get(uri.path)
          open(filename, 'wb') do |file|
            file.write(res.body)
          end
        end
      rescue => e
        fail DownloadException, e.message
      end
    end

  end
end
