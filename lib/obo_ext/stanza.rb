module Obo

  class Stanza

    # Simplified access to the id of Stanza object
    #
    # Returns an id value of self.
    def id
      self.tagvalues["id"].first
    end

    # Simplified access to parent id of Stanza object
    #
    # Returns an id value of parent Stanza.
    def parent_id
      self.tagvalues["is_a"].first
    end

    # Method checking relationship with Stanza.
    #
    # id - an identificator of Stanza to check for relationship
    # Returns bool value which idenfies if the object is parent of desired
    # Stanza.
    def parent?(id)
      self.parent_id == id
    end

  end

end