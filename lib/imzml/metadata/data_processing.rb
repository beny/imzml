module ImzML
  
  class DataProcessing
    
    # Description of the way in which a particular software was used
    # 
    # Represent by Hash with keys [order, softwareRef, actions]  
    attr_accessor :processing_method
    
    DEISOTOPING = "MS:1000033"
    CHARGE_DECONVOLUTION = "MS:1000034"
    PEAK_PICKING = "MS:1000035"
    SMOOTHING = "MS:1000592"
    BASELINE_REDUCTION = "MS:1000593"
    RETENTION_TIME_ALIGNMENT = "MS:1000745"
    CHARGE_STATE_CALCULATION = "MS:1000778"
    PRECURSOR_RECALCULATION = "MS:1000780"
    INTENSITY_NORMALIZATION = "MS:1001484"
    MZ_CALIBRATION = "MS:1001485"
    DATA_FILTERING = "MS:1001486"
    
  end
  
end