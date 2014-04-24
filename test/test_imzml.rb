require "minitest/autorun"
require_relative "helper"

class TestImzml < Minitest::Test

  EXAMPLE_CONTINUOUS = "Example_Continuous.imzML" # default
  EXAMPLE_PROCESSED = "Example_Processed.imzML"
  EXAMPLE_DROBECEK = "20130115_lin_range_10row_100vdef_0V_DOBRA2_151822.imzML"

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
    
    file_content = parser(EXAMPLE_DROBECEK).metadata.file_description.file_content
    assert_equal("MS:1000128", file_content.spectrum_representation[:accession])
    assert_equal(:continuous, file_content.binary_type)
    assert_equal("{00000000-0000-0000-0000-000000000000}", file_content.uuid)
    assert_equal("", file_content.checksum)
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
    
    software = parser(EXAMPLE_DROBECEK).metadata.software
    assert_equal("DrobControl", software.last[:id])
    assert_equal("1.0", software.last[:version])
  end

end