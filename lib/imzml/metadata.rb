module ImzML

  class Metadata
    
    # Information pertaining to the entire mzML file (i.e. not specific to any part of the data set) is stored here
    attr_accessor :file_description

    # List and descriptions of samples
    attr_accessor :samples
    
    # List and descriptions of software used to acquire and/or process the data in this mzML file
    attr_accessor :software
    
    # List with the descriptions of the acquisition settings applied prior to the start of data acquisition
    attr_accessor :scan_settings
    
    # List and descriptions of data processing applied to this data
    attr_accessor :data_processing
    
    # All mass spectra and the acquisitions underlying them are described and attached here
    attr_accessor :spectrums
        
    # Binary data types, always little endian
    BINARY_TYPE_8BIT_INTEGER = "IMS:1100000"
    BINARY_TYPE_16BIT_INTEGER = "IMS:1100001"
    BINARY_TYPE_32BIT_INTEGER = "MS:1000519"
    BINARY_TYPE_64BIT_INTEGER = "MS:1000522"
    BINARY_TYPE_32BIT_FLOAT = "MS:1000521"
    BINARY_TYPE_64BIT_FLOAT = "MS:1000523"
    
    # both can have one of the symbols [:int8, :int16, :int32, :int63, :float32, :float64]
    attr_accessor :mz_binary_data_type
    attr_accessor :intensity_binary_data_type

  end
end