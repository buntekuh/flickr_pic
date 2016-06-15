require 'mini_magick'
require 'chunky_png'

module FlickrPic
  class CreateFile
    # 
    # Creates the image file that will contain the end result
    # @param filename [filename] The filename the file should be stored as
    # @param images [Array of MiniMagick::Image] The Array of images that should be rendered on the final image
    # 
    # @return [MiniMagick::Image] The created image
    def self.create filename, images
      # force png regardless of file type defined
      filename << '.png' unless filename.end_with? 'png'
      single_image_width= images.first[:width]
      single_image_height= images.first[:height]
      items_per_side = closest_square_root images.size

      image = ChunkyPNG::Image.new(single_image_width * items_per_side, single_image_height * items_per_side, ChunkyPNG::Color::TRANSPARENT)
      image.save(filename, :interlace => true)

      MiniMagick::Image.new image
    end

    # 
    # returns the number of items along a row or column to the closest square for the given number
    # the closest square to 9 is 9 because nine is a square number, the closest square root is 3
    # the closest square to 10 is 16 because we want a square-number that can hold at least number items, the closest square root is 4
    # @param number [Integer] [description]
    # 
    # @return [Integer] [The closest square root]
    def self.closest_square_root number
      root = Math.sqrt number
      return root if root % 1 == 0
      root.ceil
    end
  end
end