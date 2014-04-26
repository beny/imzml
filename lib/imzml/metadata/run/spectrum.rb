module ImzML
  
  class Spectrum
    
    class BinaryData
      
      # A data array of m/z values
      MZ_ARRAY = "MS:1000514"
      
      # A data array of intensity values
      INTENSITY_ARRAY = "MS:1000515"
      
      # Describes how many fields an array contains
      attr_accessor :length
      EXTERNAL_ARRAY_LENGTH = "IMS:1000103"
    
      # The position where the data of an array of a mass spectrum begins
      attr_accessor :offset
      EXTERNAL_OFFSET = "IMS:1000102"
    
      # Describes the length of the written data
      attr_accessor :encoded_length
      EXTERNAL_ENCODED_LENGHT = "IMS:1000104"
      
      # grabs the actual binary data from disk
      def data
        
      end
      
    end
    
    # Attributes to describe the position of a spectrum in the image.
    # 
    # represented as Point with position x, y
    attr_accessor :position
    POSITION_X = "IMS:1000050"
    POSITION_Y = "IMS:1000051"
    
    # Info about mz binary data
    #
    # Represented by class BinaryData
    attr_accessor :mz_binary
    
    # Info about intensity binary data
    #
    # Represented by class BinaryData
    attr_accessor :intensity_binary

    
  end
  
end