module Obo

  class Parser

    # Simplified access to just Stanza objects.
    #
    # Returns an array of Obo::Stanza objects
    def stanzas
      self.elements.to_a.keep_if { |x| x.is_a?(Obo::Stanza)}
    end

    # Look for Stanza object with specific id.
    #
    # id - the "look for" identificator
    # Returns the first found Stanza object.
    def stanza(id)
      elements = self.elements.to_a.keep_if { |x| x.is_a?(Obo::Stanza) && (x.id == id)}
      elements.first if elements.is_a?(Array)
    end

    # Look for all childrens of specific Stanza object.
    #
    # id - an identificator of stanza object
    # Returns an array of Stanza children object of Stanza object.
    def children_of(id)
      self.elements.to_a.keep_if { |x| x.is_a?(Obo::Stanza) && (x.parent?(id))}
    end

  end

end
