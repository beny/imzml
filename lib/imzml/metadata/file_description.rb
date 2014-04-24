module ImzML
  
  class FileDescription
    
    # This summarizes the different types of spectra that can be expected in the file. This is expected to aid processing software in skipping files that do not contain appropriate spectrum types for it. It should also describe the nativeID format used in the file by referring to an appropriate CV term.
    attr_accessor :file_content
    
  end
  
end