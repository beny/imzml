module Obo
  
  class Parser
    
    def stanza(id)
      elements = self.elements.to_a.keep_if { |x| x.is_a?(Obo::Stanza) && (x.id == id)}
      elements.first if elements.is_a? Array
    end
    
    def children_of(id)
      self.elements.to_a.keep_if { |x| x.is_a?(Obo::Stanza) && (x.parent?(id))}
    end
    
  end
  
end
