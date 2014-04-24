module Obo
  
  class Stanza
    
    def id
      self.tagvalues[ID_TAG].first
    end
    
    def parent
      self.tagvalues[PARENT_TAG].first
    end
  
    def parent?(parent_id)
      self.parent == parent_id
    end
    
    private
    
    ID_TAG = "id"
    PARENT_TAG = "is_a"
  
  end
  
end