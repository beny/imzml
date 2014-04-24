require "minitest/autorun"
require_relative "helper"

class TestImzml < Minitest::Test

  def setup
    filepath = File.join(File.dirname(__FILE__), "..", "data", "Example_Continuous.imzML")
    @parser = ImzML::Parser.new(filepath)
  end

  def teardown

  end
  
  def test_parse
  
  
  end

  # def test_cv_list_reading
  #   
  #   cv_list = @parser.metadata.cv_list
  #   
  #   assert_equal(3, cv_list.size)
  #   assert_equal("MS", cv_list.first.id)
  #   assert_equal("Imaging MS Ontology", cv_list.last.full_name)
  #   assert_equal("0.9.1", cv_list.last.version)
  #   
  # end
  # 
  # def test_cv_file_description_reading
  #   file_description = @parser.metadata.file_description
  #   file_content = file_description.file_content
  #   
  #   assert_equal(:continuous, file_content.binary_type)
  #   assert_equal("A5BE532D25997B71BE6D20C76561DDC4D5307DDD", file_content.sha1)
  #   assert_equal("{554A27FA-79D2-4766-9A2C-862E6D78B1F3}", file_content.uuid)
  # end
  # 
  # def test_scan_setting_reading
  # 
  #   metadata = @parser.metadata
  # 
  #   assert_equal(3, metadata.pixel_count_x)
  #   assert_equal(3, metadata.pixel_count_y)
  #   # assert_equal(100, metadata.pixel_size_x) # FIXME not implemented
  #   # assert_equal(100, metadata.pixel_size_y) # FIXME not implemented
  # 
  # end
  # 
  # def test_file_content_reading
  #   metadata = @parser.metadata
  # 
  #   # assert_equal("A5BE532D25997B71BE6D20C76561DDC4D5307DDD", metadata.sha1) # FIXME not implemented
  #   assert_equal("{554A27FA-79D2-4766-9A2C-862E6D78B1F3}", metadata.uuid)
  #   assert_equal(ImzML::OBO::IMS::CONTINUOUS, metadata.saving_type)
  # 
  # end
  # 
  # def test_spectrums_readings
  #   spectrums = @parser.metadata.spectrums
  #   
  #   assert_equal(9, spectrums.size)
  #   
  #   filepath = File.join(File.dirname(__FILE__), "..", "data", "Example_Continuous.ibd")
  #   
  #   first_spectrum = spectrums.first
  #   
  #   intensity_array = first_spectrum.intensity_array(filepath)
  #   mz_array = first_spectrum.mz_array(filepath)
  #   
  #   assert_equal(8399, intensity_array.size)
  #   assert_equal(8399, mz_array.size)
  # end

end