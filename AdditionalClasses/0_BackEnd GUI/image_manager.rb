#===============================================================================================================================
# !!!   Images.rb  |  Basic utilities for drawing with ChunkyPNG can be found in here.
#-----------------------------------------------------------------------------------------------------------------------------
# Version 0.5
# Date: 2/20/19
#===============================================================================================================================
module Image_Manager
#K------------------------------------------------------------------------------------------------------------------------------
# Container for image loading and management in the program. Keeps cache of images loaded and used during draws.
#K------------------------------------------------------------------------------------------------------------------------------
  @@cachedImages = {}
  VERBOSE = false
  #---------------------------------------------------------------------------------------------------------
  #D: Load image from file, options[:type] can be used for folders located in the
  #D: media folder. options[:file] is the file name along with its extension.
  #---------------------------------------------------------------------------------------------------------
  def self.load_image(options)
    retro = options[:retro] || false
    # build single string file entry identifier
    if options.is_a?(String)
      file_location = options
    else
      file_name = options[:file] || ""
      if file_name == "" || file_name.nil?
        puts("Image Error: file_name is undefined!\n#{caller[0]}")
        return nil
      end
      file_location = File.join(ROOT, "Media", file_name)
    end
    shortdir = file_location.split('/').last
    # check cache before loading images
    unless @@cachedImages[shortdir].nil?
      return @@cachedImages[shortdir]
    end
    # check if file exists
    unless FileTest.exist?(file_location)
      puts "-" * 70
      puts "Image Error: Can't find image file:\n #{shortdir} \n"
      puts "#{file_location}\n\n"
      puts caller[0]
      puts "\n On linux file names and Directories are CASE SENSITIVE!"
      exit
      return nil
    end
    # load image data
    # https://www.rubydoc.info/github/gosu/gosu/master/Gosu/Image#initialize-instance_method
    # pixel color = image.to_blob[pix_x, pix_y].unpack("C*")
    @@cachedImages[shortdir] = Gosu::Image.new(file_location, {:retro => retro})
    raise LoadError if @@cachedImages[shortdir].nil?
    if VERBOSE
      puts("🗻(#{@@cachedImages.keys.size}) Adding new image to Cache. #{shortdir}")
    end
    return @@cachedImages[shortdir]
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Load an image then divide it into a reference table of sub image sectional tiles. Returns an Array.
  #---------------------------------------------------------------------------------------------------------
  def self.load_tiles(options)
    if options.is_a?(String)
      file_location = options
      shortdir = options.split('/').last
    else
      file_name     = options[:file]     || ""
      type          = options[:type]     || ""
      tile_width    = options[:width]    || 0
      tile_height   = options[:height]   || 0
      retro         = options[:retro]    || false
      tileable      = options[:tileable] || false
      # Auto-detect width/height from filename 
      #  image tile file foo_10x25.png would mean frame width 10px and height 25px
      if file_name =~ /_(\d+)x(\d+)/
        tile_width  = $1.to_i if tile_width  == 0
        tile_height = $2.to_i if tile_height == 0
      end
      file_location = File.join(ROOT, "Media", file_name)
      shortdir = file_name
    end
    # check if file exists
    unless FileTest.exist?(file_location)
      puts("🗻 Can't find tile image file:\n #{file_location}\n")
      puts("  Is asking: #{caller[0]}")
      exit
    end
    # load image data
    # https://www.rubydoc.info/github/gosu/gosu/Gosu/Image#load_tiles-class_method
    tiles = Gosu::Image.load_tiles(file_location, tile_width, tile_height, {:retro => retro, :tileable => tileable})
    raise LoadError if tiles.nil?
    if VERBOSE
      puts("🗻 Built new tilemap id image table (#{tiles.size}). #{shortdir}")
    end
    return tiles
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Clears the chache table of all loaded images used.
  #---------------------------------------------------------------------------------------------------------
  def self.clearCache
    @@cachedImages = {}
  end
end