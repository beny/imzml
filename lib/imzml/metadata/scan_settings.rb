module ImzML

  # Class representing elements from scanSettingsList.
  class ScanSettings

    # Description in wich direction the lines of the sample were scanned
    attr_accessor :line_scan_direction
    LINE_SCAN_BOTTOM_UP = "IMS:1000492"
    LINE_SCAN_LEFT_RIGHT = "IMS:1000491"
    LINE_SCAN_RIGHT_LEFT = "IMS:1000490"
    LINE_SCAN_TOP_DOWN = "IMS:1000493"

    # Description of the direction of the succession of the assembling of the linescans
    attr_accessor :scan_direction
    BOTTOM_UP = "IMS:1000400"
    LEFT_RIGHT = "IMS:1000402"
    RIGHT_LEFT = "IMS:1000403"
    TOP_DOWN = "IMS:1000401"

    # Description of the pattern how the image was scanned
    attr_accessor :scan_pattern
    MEANDERING = "IMS:1000410"
    ONE_WAY = "IMS:1000411"
    RANDOM_ACCESS = "IMS:1000412"
    FLY_BACK = "IMS:1000413"

    # Shows the direction in which the lines were scanned
    attr_accessor :scan_type
    HORIZONTAL_LINE_SCAN = "IMS:1000480"
    VERTICAL_LINE_SCAN = "IMS:1000481"

    # Sample properties only concerning imaging samples
    attr_accessor :image
    MAX_DIMENSION_X = "IMS:1000044"
    MAX_DIMENSION_Y = "IMS:1000045"
    MAX_COUNT_OF_PIXEL_X = "IMS:1000042"
    MAX_COUNT_OF_PIXEL_Y = "IMS:1000043"
    PIXEL_SIZE_X = "IMS:1000046"
    PIXEL_SIZE_Y = "IMS:1000047"

  end

end