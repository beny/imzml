require "minitest/autorun"
require_relative "helper"

class TestImzml < Minitest::Test

  EXAMPLE_CONTINUOUS = "Example_Continuous.imzML" # default
  EXAMPLE_PROCESSED = "Example_Processed.imzML"
  
  ## Test with large file, it's not attached because it would make the gem
  # incredible large and the test wouldn't be so fast
  
  # EXAMPLE_DROBECEK = "20130115_lin_range_10row_100vdef_0V_DOBRA2_151822.imzML"
  # EXAMPLE_LARGE = "20121220_LIN_100x100_1mmScan_PAPER_0018_spot5_1855.imzML"

  def parser(filename = EXAMPLE_CONTINUOUS)
    filepath = File.join(File.dirname(__FILE__), "..", "data", filename)
    @parser = ImzML::Parser.new(filepath)
  end

  def test_file_content
    file_content = parser.metadata.file_description.file_content
    assert_equal("MS:1000128", file_content.spectrum_representation[:accession])
    assert_equal(:continuous, file_content.binary_type)
    assert_equal("{554A27FA-79D2-4766-9A2C-862E6D78B1F3}", file_content.uuid)
    assert_equal("A5BE532D25997B71BE6D20C76561DDC4D5307DDD", file_content.checksum)

    file_content = parser(EXAMPLE_PROCESSED).metadata.file_description.file_content
    assert_equal("MS:1000128", file_content.spectrum_representation[:accession])
    assert_equal(:processed, file_content.binary_type)
    assert_equal("{9D501BDC-5344-4916-B7E9-7E795B02C856}", file_content.uuid)
    assert_equal("7E8FDB93053915D3EDB51B70AA0619AC209964DF", file_content.checksum)
    
    # file_content = parser(EXAMPLE_DROBECEK).metadata.file_description.file_content
    # assert_equal("MS:1000128", file_content.spectrum_representation[:accession])
    # assert_equal(:continuous, file_content.binary_type)
    # assert_equal("{00000000-0000-0000-0000-000000000000}", file_content.uuid)
    # assert_equal("", file_content.checksum)
  end
  
  def test_source_file_list
    skip "not implemented"
  end
  
  def test_contact
    skip "not implemented"
  end
  
  def test_sample_list
    
    samples = parser.metadata.samples
    assert(samples.key?(:sample1))
    assert_equal(1, samples[:sample1][:value].to_i)
    assert_equal("MS:1000001", samples[:sample1][:accession])
    
    samples = parser(EXAMPLE_PROCESSED).metadata.samples
    assert(samples.key?(:sample1))
    assert_equal(1, samples[:sample1][:value].to_i)
    assert_equal("MS:1000001", samples[:sample1][:accession])
  end
  
  def test_software_list
    
    software = parser.metadata.software
    assert_equal("Xcalibur", software.first[:id])
    assert_equal("2.2", software.first[:version])
    
    software = parser(EXAMPLE_PROCESSED).metadata.software
    assert_equal("TMC", software.last[:id])
    assert_equal("1.1 beta", software.last[:version])
    
    # software = parser(EXAMPLE_DROBECEK).metadata.software
    # assert_equal("DrobControl", software.last[:id])
    # assert_equal("1.0", software.last[:version])
  end

  def test_scan_settins
    settings = parser.metadata.scan_settings[:scansettings1]
    assert_equal(3, settings.image.max_pixel_count.x, "Max count pixel x does not match")
    assert_equal(3, settings.image.max_pixel_count.y, "Max count pixel y does not match")
    assert_equal(100, settings.image.pixel_size.x, "Pixel size x does not match")
    assert_equal(100, settings.image.pixel_size.y, "Pixel size y does not match")
    assert_equal(:horizontal, settings.scan_type, "Scan type does not match")
    assert_equal(:left_right, settings.line_scan_direction, "Line scan direction does not match")
    assert_equal(:fly_back, settings.scan_pattern, "Scan pattern does not match")
    assert_equal(:top_down, settings.scan_direction, "Scan direction does not match")
    
    settings = parser(EXAMPLE_PROCESSED).metadata.scan_settings[:scansettings1]
    assert_equal(3, settings.image.max_pixel_count.x, "Max count pixel x does not match")
    assert_equal(3, settings.image.max_pixel_count.y, "Max count pixel y does not match")
    assert_equal(100, settings.image.pixel_size.x, "Pixel size x does not match")
    assert_equal(100, settings.image.pixel_size.y, "Pixel size y does not match")
    assert_equal(:horizontal, settings.scan_type, "Scan type does not match")
    assert_equal(:left_right, settings.line_scan_direction, "Line scan direction does not match")
    assert_equal(:fly_back, settings.scan_pattern, "Scan pattern does not match")
    assert_equal(:top_down, settings.scan_direction, "Scan direction does not match")
    
    # settings = parser(EXAMPLE_DROBECEK).metadata.scan_settings[:ScanSettings]
    # assert_equal(50, settings.image.max_pixel_count.x, "Max count pixel x does not match")
    # assert_equal(3, settings.image.max_pixel_count.y, "Max count pixel y does not match")
    # assert_equal(100, settings.image.pixel_size.x, "Pixel size x does not match")
    # assert_equal(50, settings.image.pixel_size.y, "Pixel size y does not match")
    # assert_equal(:horizontal, settings.scan_type, "Scan type does not match")
    # assert_equal(:left_right, settings.line_scan_direction, "Line scan direction does not match")
    # assert_equal(:meandering, settings.scan_pattern, "Scan pattern does not match")
    # assert_equal(:bottom_up, settings.scan_direction, "Scan direction does not match")
  end

  def test_instrument_configurations
    skip "not implemented"
  end
  
  def test_data_processing_list

    data_processing = parser.metadata.data_processing
    assert(data_processing, "data processing should exists")
    assert_equal(2, data_processing.size)
    assert(data_processing.key?(:XcaliburProcessing), "Data processing should have this processing")
    assert_equal(1, data_processing[:XcaliburProcessing].processing_method[:actions].size)
    assert_equal("MS:1000594", data_processing[:XcaliburProcessing].processing_method[:actions].first[:accession])
    assert_equal("MS:1000544", data_processing[:TMCConversion].processing_method[:actions].first[:accession])
    
    data_processing = parser(EXAMPLE_PROCESSED).metadata.data_processing
    assert(data_processing, "data processing should exists")
    assert_equal(2, data_processing.size)
    assert(data_processing.key?(:XcaliburProcessing), "Data processing should have this processing")
    assert_equal(1, data_processing[:XcaliburProcessing].processing_method[:actions].size)
    assert_equal("MS:1000594", data_processing[:XcaliburProcessing].processing_method[:actions].first[:accession])
    assert_equal("MS:1000544", data_processing[:TMCConversion].processing_method[:actions].first[:accession])
    
    # data_processing = parser(EXAMPLE_DROBECEK).metadata.data_processing
    # assert(data_processing, "data processing should exists")
    # assert_equal(1, data_processing.size)
    # assert(data_processing.key?(:DrobControlAQ), "Data processing should have this processing")
    # assert_equal(1, data_processing[:DrobControlAQ].processing_method[:actions].size)
    # assert_equal("MS:1001486", data_processing[:DrobControlAQ].processing_method[:actions].first[:accession])
    
  end
  
  def test_spectrum_list
    
    spectrums = parser.metadata.spectrums
    assert_equal(9, spectrums.size)
    spectrum = spectrums[:"Scan=6"]
    assert_equal(3, spectrum.position.x)
    assert_equal(2, spectrum.position.y)
    assert_equal(8399, spectrum.mz_binary.length)
    assert_equal(16, spectrum.mz_binary.offset)
    assert_equal(33596, spectrum.mz_binary.encoded_length)
    assert_equal(8399, spectrum.intensity_binary.length)
    assert_equal(201592, spectrum.intensity_binary.offset)
    assert_equal(33596, spectrum.intensity_binary.encoded_length)

    spectrums = parser(EXAMPLE_PROCESSED).metadata.spectrums    
    assert_equal(9, spectrums.size)
    spectrum = spectrums[:"Scan=8"]
    assert_equal(2, spectrum.position.x)
    assert_equal(3, spectrum.position.y)
    assert_equal(8399, spectrum.mz_binary.length)
    assert_equal(470360, spectrum.mz_binary.offset)
    assert_equal(33596, spectrum.mz_binary.encoded_length)
    assert_equal(8399, spectrum.intensity_binary.length)
    assert_equal(503956, spectrum.intensity_binary.offset)
    assert_equal(33596, spectrum.intensity_binary.encoded_length)
    
    # spectrums = parser(EXAMPLE_DROBECEK).metadata.spectrums    
    # assert_equal(150, spectrums.size)
    # spectrum = spectrums[:"Scan=40"]
    # assert_equal(40, spectrum.position.x)
    # assert_equal(1, spectrum.position.y)
    # assert_equal(17753, spectrum.mz_binary.length)
    # assert_equal(16, spectrum.mz_binary.offset)
    # assert_equal(71012, spectrum.mz_binary.encoded_length)
    # assert_equal(17753, spectrum.intensity_binary.length)
    # assert_equal(2840496, spectrum.intensity_binary.offset)
    # assert_equal(71012, spectrum.intensity_binary.encoded_length)
    #     
    # spectrums = parser(EXAMPLE_LARGE).metadata.spectrums
    # spectrum = spectrums[:"Scan=6156"]
    # assert_equal(45, spectrum.position.x)
    # assert_equal(62, spectrum.position.y)
    # assert_equal(2954, spectrum.mz_binary.length)
    # assert_equal(16, spectrum.mz_binary.offset)
    # assert_equal(11816, spectrum.mz_binary.encoded_length)
    # assert_equal(2954, spectrum.intensity_binary.length)
    # assert_equal(72739312, spectrum.intensity_binary.offset)
    # assert_equal(11816, spectrum.intensity_binary.encoded_length)
    
  end
  
  def test_binary_data_type
    
    metadata = parser.metadata
    
    assert_equal(:float32, metadata.mz_binary_data_type)
    assert_equal(:float32, metadata.intensity_binary_data_type)
    
  end

end
