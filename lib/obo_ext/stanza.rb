module Obo
  
  class Stanza
    
    def id
      self.tagvalues[ID_TAG].first
    end
    
    def parent_id
      self.tagvalues[PARENT_TAG].first
    end
  
    def parent?(id)
      self.parent_id == id
    end
    
    private
    
    ID_TAG = "id"
    PARENT_TAG = "is_a"
  
  end
  
end