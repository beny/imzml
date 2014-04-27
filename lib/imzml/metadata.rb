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

  end
end