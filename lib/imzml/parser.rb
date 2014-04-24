require "ox"

module ImzML
  
  class Parser
    
    attr_reader :metadata
    
    def initialize(filepath)
      
      sax = ImzML::Sax.new
      Ox.sax_parse(sax, File.open(filepath))
      @metadata = sax.metadata
      
      
    end
    
  end
  
  class Sax < ::Ox::Sax

    attr_reader :metadata

    def initialize()
      # @metadata = Metadata.new
      @stack = Array.new
      @elements = Array.new
      
      @obo = Hash.new
    end

    def start_element(name)
      # p "#{@stack.last} #{@elements.last}"
      @stack.push(name)
      @elements.push(Hash.new)
      # p "#{name} started"
      # p @stack
      
      
      case name
      when :cvList
        @cv_list = []
      when :cv
        @cv_list << @elements.last
      end
    end

    def attr(name, str)
      element = @elements.last
      return if element.nil? # skip attributes without correct elements (like <?xml ...)
      element[name] = str
    end

    def end_element(name)
      @stack.pop
      element = @elements.pop
      # p @stack
      
      # open OBO file for each from CV list for further validation
      if name == :cvList
        @cv_list.each do |cv|
          filename = case cv[:id]
          when "MS"
            "psi-ms.obo"
          when "UO"
            "unit.obo"
          when "IMS"
            "imagingMS.obo"
          end
          filepath = File.join(File.dirname(__FILE__), "..", "..", "data", filename)
          @obo[cv[:id].to_s] = Obo::Parser.new(filepath)
          
        end
        
        # @obo["MS"].stanza("MS:1001479").parent?("MS:1000518")
      end
      
      # parse file content
      if name == :cvParam && @stack.last == :fileContent
        
        stanza = @obo[element[:cvRef]]
        
        # case stanza.
        
      end
      
      # p "#{name} ended #{element}"

    end
  end
  
end