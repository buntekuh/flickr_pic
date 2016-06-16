require 'mini_magick'

module FlickrPic
  # 
  # Crops the downloaded images
  # 
  # @author [buntekuh]
  # 
  class ImageCropper
      # 
      # Crops all presumed image files in a directory to given dimensions
      # @param directory [String] The directory which contains the images
      # @param width [Integer] The desired width
      # @param height [Integer] The desired height
      # 
    def self.crop_images_in_dir directory, width, height
      Dir[File.join(directory, '*')].collect do |filename|
        crop MiniMagick::Image.new(filename), width, height
      end
    end

    # 
    # Crops a MiniMagick image to desired width and height
    # @param img [MiniMagick Image] The image to crop
    # @param w [Integer] The desired width
    # @param h [Integer] The desired height
    # @see https://gist.github.com/maxivak/3924976
    # I do not claim to understand any of this
    # 
    def self.crop img, w, h
      w_original, h_original = [img[:width].to_f, img[:height].to_f]

      op_resize = ''

      # check proportions
      if w_original * h < h_original * w
        op_resize = "#{w.to_i}x"
        w_result = w
        h_result = (h_original * w / w_original)
      else
        op_resize = "x#{h.to_i}"
        w_result = (w_original * h / h_original)
        h_result = h
      end

      w_offset, h_offset = crop_offsets_by_gravity(:center, [w_result, h_result], [ w, h])

      img.combine_options do |i|
        i.resize(op_resize)
        i.gravity(:center)
        i.crop "#{w.to_i}x#{h.to_i}+#{w_offset}+#{h_offset}!"
      end

      img
    end

    # 
    # Does Mini magick
    # @see https://gist.github.com/maxivak/3924976
    # I do not claim to understand any of this
    def self.crop_offsets_by_gravity(gravity, original_dimensions, cropped_dimensions)
      original_width, original_height = original_dimensions
      cropped_width, cropped_height = cropped_dimensions

      vertical_offset = case gravity
        when :north_west, :north, :north_east then 0
        when :center, :east, :west then [ ((original_height - cropped_height) / 2.0).to_i, 0 ].max
        when :south_west, :south, :south_east then (original_height - cropped_height).to_i
      end

      horizontal_offset = case gravity
        when :north_west, :west, :south_west then 0
        when :center, :north, :south then [ ((original_width - cropped_width) / 2.0).to_i, 0 ].max
        when :north_east, :east, :south_east then (original_width - cropped_width).to_i
      end

      return [ horizontal_offset, vertical_offset ]
    end                                                                                            
  end
end