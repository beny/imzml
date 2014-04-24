require "minitest/autorun"
require_relative "helper"

class TestOboExt < Minitest::Test

  def setup
    filepath = File.join(File.dirname(__FILE__), "..", "data", "psi-ms.obo")
    @parser = Obo::Parser.new(filepath)
  end
  
  def test_find_specific_stanza
    id = "MS:1000563"
    stanza = @parser.stanza(id)
    assert_equal(id, stanza.id)
  end
  
  def test_parent_check
    id = "MS:1001369"
    stanza = @parser.stanza(id)
    assert(stanza.parent?("MS:1000560"), "Parent for this stanza should be set there")
  end
  
  def test_children
    childrens = @parser.children_of("MS:1000518").map { |x| x["name"]}
    assert_equal(6, childrens.size)
  end
  
end