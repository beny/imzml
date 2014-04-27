class Array
  
  def binary_search(value, first = true)
    
    if (self.size > 2)
      middle_index = self.size/2
      middle = self[middle_index]

      if (middle > value)
        self[0..middle_index].binary_search(value, first)
      else
        self[middle_index..self.size].binary_search(value, first)
      end
    else
      if first
        self.first
      else
        self.last
      end
    end
  end
  
end