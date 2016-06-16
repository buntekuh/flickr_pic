require 'mini_magick'
require 'chunky_png'

module FlickrPic
  # 
  # Creates the final images and assembles the subimages there on
  # 
  # @author [buntekuh]
  # 
  class CreateFile
    class FileWriteError < StandardError; end

    attr_accessor :image, :filename, :images, :single_image_width, :single_image_height, :items_per_side
    
    def initialize filename, images
      self.filename = filename
      self.images = images
      self.single_image_width= images.first[:width]
      self.single_image_height= images.first[:height]
      self.items_per_side = closest_square_root images.size
      
      # force png regardless of file type defined
      # TODO allow different file type
      self.filename = "#{filename}.png" unless filename.end_with? '.png'
      file_writable?

      `convert -size #{@items_per_side * single_image_width}x#{@items_per_side * single_image_height} canvas:transparent #{self.filename}`
      
      self.image = MiniMagick::Image.new self.filename
    end
    
    # 
    # Creates the image file that will contain the end result
    # @param filename [filename] The filename the file should be stored as
    # @param images [Array of MiniMagick::Image] The Array of images that should be rendered on the final image
    # 
    # @return [MiniMagick::Image] The created image
    def self.execute filename, images
      
      file = self.new filename, images

      file.make_collage
      
      file.image
    end

    # 
    # This renders the subimages onto the result
    # 
    def make_collage
      0.upto(images.size - 1) do |n|
        column, row = column_row n
        compose images[n], column * single_image_width, row * single_image_height
      end
      image.write filename
    end

    # 
    # The subimages are positioned into a patchwork pattern
    # Calculates which row and column the nth subimage should be rendered to
    # @param number [Integer] Image counter
    # 
    # @return [Array of two Integers] Column and Row
    def column_row number
      [number % items_per_side, number / items_per_side]
    end

    # 
    # Does the actual MiniMagick composition (rendering)
    # @param source [MiniMagick::Image] The image to be rendered onto the final image
    # @param x_offset [Integer] The x offset within the final image
    # @param y_offset [Integer] The y offset within the final image
    # 
    def compose source, x_offset, y_offset
      result = image.composite(source) do |c|
        c.compose "Over"
        c.geometry "+#{x_offset}+#{y_offset}"
      end
      self.image = result
    end

    private

    # 
    # returns the number of items along a row or column to the closest square for the given number
    # the closest square to 9 is 9 because nine is a square number, the closest square root is 3
    # the closest square to 10 is 16 because we want a square-number that can hold at least number items, the closest square root is 4
    # @param number [Integer] [description]
    # 
    # @return [Integer] [The closest square root]
    def closest_square_root number
      root = Math.sqrt number
      return root.to_i if root % 1 == 0
      root.ceil.to_i
    end

    # 
    # Tests wether the final file can be written
    # 
    # @raises FileWriteError if file could not be created
    def file_writable?
      path, name = File.split(filename)
      fail FileWriteError, 'could not create file' unless File.writable?(path)
      true
    end
  end
end