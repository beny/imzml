module ImzML

    class FileContent
      
      # must containt one or more of children
      attr_accessor :data_file_contents
      DATA_FILE_CONTENT = "MS:1000524"
      TOTAL_ION_CURRENT_CHROMATOGRAM = "MS:1000235"
      CHARGE_INVERSION_MASS_SPECTRUM = "MS:1000322"
      CONSTANT_NEUTRAL_GAIN_SPECTRUM = "MS:1000325"
      CONSTANT_NEUTRAL_LOSS_SPECTRUM = "MS:1000326"
      E_2_MASS_SPECTRUM = "MS:1000328"
      PRECURSOR_ION_SPECTRUM = "MS:1000341"
      
      # may supply just one of children
      attr_accessor :spectrum_representation
      SPECTRUM_REPRESENTATION = "MS:1000525"
      CENTROID_SPECTRUM = "MS:1000127"
      PROFILE_SPECTRUM = "MS:1000128"

      # Describes type of the binary (ibd) file
      attr_accessor :binary_type
      IBD_BINARY_TYPE = "IMS:1000003"
      CONTINUOUS = "IMS:1000030"
      PROCESSED = "IMS:1000031"
      
      # Checksum is a form of redundancy check, a simple way to protect the integrity of data by detecting errors in data of the ibd file
      attr_accessor :checksum
      IBD_CHECKSUM = "IMS:1000009"
      MD5 = "IMS:1000090"
      SHA1 = "IMS:1000091"
      
      # Attributes to doubtlessly identify the ibd file
      attr_accessor :uuid
      IBD_IDENTIFICATION = "IMS:1000008"
      UNIVERSALLY_UNIQUE_IDENTIFIER = "IMS:1000080"
      
      # TODO ibd file
      
    end
  
end