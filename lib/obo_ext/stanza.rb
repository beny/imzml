module Obo
  
  class Stanza
    
    def id
      self.tagvalues["id"].first
    end
    
    def parent_id
      self.tagvalues["is_a"].first
    end
  
    def parent?(id)
      self.parent_id == id
    end
    
  end
  
end