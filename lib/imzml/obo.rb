module ImzML

  module OBO

    module MS

      FLOAT_32_BIT = "MS:1000521"

    end

    module IMS

      CONTINUOUS = "IMS:1000030"
      PROCESSED = "IMS:1000031"
      EXTERNAL_OFFSET = "IMS:1000102"
      EXTERNAL_ENCODED_LENGTH = "IMS:1000104"
      MAX_COUNT_OF_PIXELS_X = "IMS:1000042"
      MAX_COUNT_OF_PIXELS_Y = "IMS:1000043"
      PIXEL_SIZE = "IMS:1000046"
      IMAGE_SHAPE = "IMS:1000047"
      UNIVERSALLY_UNIQUE_IDENTIFIER = "IMS:1000080"
      
      SPECTRUM_POSITION = "IMS:1000005"
      SPECTRUM_POSITION_X = "IMS:1000050"
      SPECTRUM_POSITION_Y = "IMS:1000051"
      SPECTRUM_POSITION_Z = "IMS:1000052"

      # attributes of the generation of the image
      LINESCAN_SEQUENCE = "IMS:1000040"
      LINESCAN_SEQUENCE_BOTTOM_UP = "IMS:1000400"
      LINESCAN_SEQUENCE_TOP_DOWN = "IMS:1000401"
      LINESCAN_SEQUENCE_LEFT_RIGHT = "IMS:1000402"
      LINESCAN_SEQUENCE_RIGHT_LEFT = "IMS:1000403"
      LINESCAN_SEQUENCE_NO_DIRECTION = "IMS:1000404"

      SCAN_PATTERN = "IMS:1000041"
      SCAN_PATTERN_MEANDERING = "IMS:1000410"
      SCAN_PATTERN_RANDOM_ACCESS = "IMS:1000412"
      SCAN_PATTERN_FLYBACK = "IMS:1000413"

      SCAN_TYPE = "IMS:1000048"
      SCAN_TYPE_HORIZONTAL_LINE_SCAN = "IMS:1000480"
      SCAN_TYPE_VERTICAL_LINE_SCAN = "IMS:1000481"

      LINE_SCAN_DIRECTION = "IMS:1000049"
      LINE_SCAN_DIRECTION_LINESCAN_RIGHT_LEFT = "IMS:1000490"
      LINE_SCAN_DIRECTION_LINESCAN_LEFT_RIGHT = "IMS:1000491"
      LINE_SCAN_DIRECTION_LINESCAN_BOTTOM_UP = "IMS:1000492"
      LINE_SCAN_DIRECTION_LINESCAN_TOP_DOWN = "IMS:1000493"

    end

    module UNIT
    end
  end

end