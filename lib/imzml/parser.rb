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
      @metadata = Metadata.new
      @stack = Array.new
      @elements = Array.new
      
      # temporary values useful just for data parsing
      @reference_groups = Hash.new
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
      end

      # save file content
      if name == :cvParam && @stack.last == :fileContent
        
        cv = @obo[element[:cvRef]]
        stanza = cv.stanza(element[:accession])
        parent_id = stanza.parent_id

        # init basic structures
        @metadata.file_description ||= FileDescription.new
        file_content = (@metadata.file_description.file_content ||= FileContent.new)
        
        case element[:cvRef]
        when "MS"
          # save data file content
          if parent_id == FileContent::DATA_FILE_CONTENT
            file_content.data_file_contents ||= Hash.new
            (file_content.data_file_contents[parent_id] ||= Array.new) << element
          end
        
          # save spectrum representation
          if parent_id == FileContent::SPECTRUM_REPRESENTATION
            file_content.spectrum_representation = element
          end
        
        when "IMS"
          # save binary type (cannot look by parent because the OBO file is different and 
          # the parser doesn't hadle it well, need to first improve the OBO parser)
          if stanza.id == FileContent::CONTINUOUS
            file_content.binary_type = :continuous
          elsif stanza.id == FileContent::PROCESSED
            file_content.binary_type = :processed
          end
          
          # save checksum type
          if stanza.id == FileContent::MD5
            file_content.checksum = element[:value]
          elsif stanza.id == FileContent::SHA1
            file_content.checksum = element[:value]
          end
          
          # save identifier
          if stanza.id == FileContent::UNIVERSALLY_UNIQUE_IDENTIFIER
            file_content.uuid = element[:value]
          end
        end
        
      end

      # save reference group for further usage
      if name == :cvParam && @stack.last == :referenceableParamGroup
        @reference_groups[@elements.last[:id].to_sym] = element
      end
      # p @reference_groups if name == :referenceableParamGroup
      
      # save sample list
      if name == :cvParam && @stack.last == :sample
        samples = (@metadata.samples ||= Hash.new)
        samples[@elements.last[:id].to_sym] = element
      end
      # p @metadata.samples if name == :sampleList
      
      # save software list
      if name == :software && @stack.last == :softwareList
        (@metadata.software ||= Array.new) << element
      end
      # p @metadata.software if name == :softwareList
      
      if name == :cvParam && @stack.last == :scanSettings
        scan_settings = (@metadata.scan_settings ||= Hash.new)
        setting = (scan_settings[@elements.last[:id].to_sym] ||= ScanSettings.new)
        
        cv = @obo[element[:cvRef]]
        stanza = cv.stanza(element[:accession])
        parent_id = stanza.parent_id
        
        case element[:cvRef]
        when "IMS"
          
          # detect correct line scan direction
          setting.line_scan_direction = case stanza.id
          when ScanSettings::LINE_SCAN_BOTTOM_UP
            :bottom_up
          when ScanSettings::LINE_SCAN_LEFT_RIGHT
            :left_right
          when ScanSettings::LINE_SCAN_RIGHT_LEFT
            :right_left
          when ScanSettings::LINE_SCAN_TOP_DOWN
            :top_down
          else
            setting.line_scan_direction
          end
          
          # detect scan direction
          setting.scan_direction = case stanza.id
          when ScanSettings::BOTTOM_UP
            :bottom_up
          when ScanSettings::LEFT_RIGHT
            :left_right
          when ScanSettings::RIGHT_LEFT
            :right_left
          when ScanSettings::TOP_DOWN
            :top_down
          else
            setting.scan_direction
          end
          
          # detect scan pattern
          setting.scan_pattern = case stanza.id
          when ScanSettings::MEANDERING
            :meandering
          when ScanSettings::ONE_WAY
            :one_way
          when ScanSettings::RANDOM_ACCESS
            :random_access
          when ScanSettings::FLY_BACK
            :fly_back
          else
            setting.scan_pattern
          end
          
          # detect scan type
          setting.scan_type = case stanza.id
          when ScanSettings::HORIZONTAL_LINE_SCAN
            :horizontal
          when ScanSettings::VERTICAL_LINE_SCAN
            :vertical
          else
            setting.scan_type
          end
          
          # detect image properties
          image = (setting.image ||= ImzML::Image.new)
          
          case stanza.id
          when ScanSettings::MAX_DIMENSION_X
            point = (image.max_dimension ||= ImzML::Point.new)
            point.x = element[:value].to_i  
          when ScanSettings::MAX_DIMENSION_Y
            point = (image.max_dimension ||= ImzML::Point.new)
            point.y = element[:value].to_i
          when ScanSettings::MAX_COUNT_OF_PIXEL_X
            point = (image.max_pixel_count ||= ImzML::Point.new)
            point.x = element[:value].to_i
          when ScanSettings::MAX_COUNT_OF_PIXEL_Y
            point = (image.max_pixel_count ||= ImzML::Point.new)
            point.y = element[:value].to_i
          when ScanSettings::PIXEL_SIZE_X
            point = (image.pixel_size ||= ImzML::Point.new)
            point.x = element[:value].to_i
          when ScanSettings::PIXEL_SIZE_Y
            point = (image.pixel_size ||= ImzML::Point.new)
            point.y = element[:value].to_i
          end
        end
        
        # [
        #   {:cvRef=>"IMS", :accession=>"IMS:1000401", :name=>"top down", :value=>""},
        #   {:cvRef=>"IMS", :accession=>"IMS:1000413", :name=>"flyback", :value=>""},
        #   {:cvRef=>"IMS", :accession=>"IMS:1000480", :name=>"horizontal line scan", :value=>""},
        #   {:cvRef=>"IMS", :accession=>"IMS:1000491", :name=>"linescan left right", :value=>""},
        #   {:cvRef=>"IMS", :accession=>"IMS:1000042", :name=>"max count of pixel x", :value=>"3"},
        #   {:cvRef=>"IMS", :accession=>"IMS:1000043", :name=>"max count of pixel y", :value=>"3"},
        #   {:cvRef=>"IMS", :accession=>"IMS:1000044", :name=>"max dimension x", :value=>"300", :unitCvRef=>"UO", :unitAccession=>"UO:0000017", :unitName=>"micrometer"},
        #   {:cvRef=>"IMS", :accession=>"IMS:1000045", :name=>"max dimension y", :value=>"300", :unitCvRef=>"UO", :unitAccession=>"UO:0000017", :unitName=>"micrometer"},
        #   {:cvRef=>"IMS", :accession=>"IMS:1000046", :name=>"pixel size x", :value=>"100", :unitCvRef=>"UO", :unitAccession=>"UO:0000017", :unitName=>"micrometer"},
        #   {:cvRef=>"IMS", :accession=>"IMS:1000047", :name=>"pixel size y", :value=>"100", :unitCvRef=>"UO", :unitAccession=>"UO:0000017", :unitName=>"micrometer"},
        #   {:cvRef=>"MS", :accession=>"MS:1000836", :name=>"dried dropplet", :value=>""},
        #   {:cvRef=>"MS", :accession=>"MS:1000835", :name=>"matrix solution concentration", :value=>"10"},
        #   {:cvRef=>"MS", :accession=>"MS:1000834", :name=>"matrix solution", :value=>"DHB"}
        # ]
      end
      # p @metadata.scan_settings if name == :scanSettingsList

      # p "#{name} ended #{element}"

    end
  end

end