require "minitest/autorun"
require_relative "helper"

class TestOboExt < Minitest::Test

  def setup
    filepath = File.join(File.dirname(__FILE__), "..", "data", "psi-ms.obo")
    @ms_parser = Obo::Parser.new(filepath)
  end
  
  def test_find_specific_stanza
    id = "MS:1000563"
    stanza = @ms_parser.stanza(id)
    assert_equal(id, stanza.id)
  end
  
  def test_parent_check
    id = "MS:1001369"
    stanza = @ms_parser.stanza(id)
    assert(stanza.parent?("MS:1000560"), "Parent for this stanza should be set there")
  end
  
  def test_children
    childrens = @ms_parser.children_of("MS:1000518").map { |x| x["name"]}
    assert_equal(6, childrens.size)
  end
  
  # FIXME this test is just for easier searching in OBO files
  def test_data_processing_children
    p @ms_parser.children_of("MS:1000543").map { |x| [x.tagvalues["name"].first, x.id]}
    
  end
  
end