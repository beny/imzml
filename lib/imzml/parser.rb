require "ox"

module ImzML

  # Parser class which handles the input to the SAX class and returns correct
  # output.
  class Parser

    attr_reader :metadata

    # Initizalize the parser itself.
    #
    # filepath - String path to the imzML file
    # binary_filepath - String path to the ibd, if not provided, same name as
    #                   in filepath is used
    def initialize(filepath, binary_filepath = nil)

      sax = ImzML::Sax.new

      # If no external file were specified, behave like the file has the same name
      # as the metadata
      if binary_filepath.nil?
        name = filepath.split(".")[0..-2].join(".")
        binary_filepath = [name, "ibd"].join(".")
      end
      sax.binary_filepath = binary_filepath

      # parse the XML
      Ox.sax_parse(sax, File.open(filepath))
      @metadata = sax.metadata

    end

  end

  # Customized SAX parser which inherits from Ox::Sax base class.
  class Sax < ::Ox::Sax

    # Instance of object ImzML::Metadata
    attr_reader :metadata

    # String path to the binary file
    attr_accessor :binary_filepath

    # Both can have one of the symbols [:int8, :int16, :int32, :int64, :float32, :float64]
    attr_accessor :mz_binary_data_type
    attr_accessor :intensity_binary_data_type

    def initialize()
      @metadata = Metadata.new
      @stack = Array.new
      @elements = Array.new

      # temporary values useful just for data parsing
      @reference_groups = Hash.new
      @obo = Hash.new
    end

    # Method called when parser enters the element
    #
    # name - Symbol name of the starting element
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

    # Method called when parser enters the attribute of an element.
    #
    # name - Symbol name of the attribute
    # str - String value of the attribute
    def attr(name, str)
      element = @elements.last
      return if element.nil? # skip attributes without correct elements (like <?xml ...)
      element[name] = str
    end

    # Method called when parser ends element.
    #
    # name - Symbol name of ending element
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
        (@reference_groups[@elements.last[:id].to_sym] ||= Array.new) << element
      end

      # save sample list
      if name == :cvParam && @stack.last == :sample
        samples = (@metadata.samples ||= Hash.new)
        samples[@elements.last[:id].to_sym] = element
      end

      # save software list (raw, without detailed parsing)
      if name == :software && @stack.last == :softwareList
        (@metadata.software ||= Array.new) << element
      end

      # save scan settings
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

      end

      # parse processing methods
      if name == :cvParam && @stack.last == :processingMethod
        data_processing = (@metadata.data_processing ||= Hash.new)
        processing = (data_processing[@elements[-2][:id].to_sym] ||= DataProcessing.new)
        processing.processing_method = @elements.last
        (processing.processing_method[:actions] ||= Array.new) << element
      end

      # save spectrum position info
      if name == :cvParam && @stack.last == :scan
        spectrums = (@metadata.spectrums ||= Hash.new)
        spectrum = (spectrums[@elements[-3][:id].to_sym] ||= Spectrum.new)
        point = (spectrum.position ||= ImzML::Point.new)

        point.x = element[:value].to_i if element[:accession] == Spectrum::POSITION_X
        point.y = element[:value].to_i if element[:accession] == Spectrum::POSITION_Y
      end

      # save spectrum binary data info
      if name == :referenceableParamGroupRef && @stack.last == :binaryDataArray
        group = @reference_groups[element[:ref].to_sym]

        spectrum = @metadata.spectrums[@elements[-3][:id].to_sym]
        mz_binary = (spectrum.mz_binary ||= ImzML::Spectrum::BinaryData.new)
        intensity_binary = (spectrum.intensity_binary ||= ImzML::Spectrum::BinaryData.new)

        # detect type of the binary data info based on referenced group content
        group.each do |param|
          # p param
          @binary_type = case param[:accession]
          when ImzML::Spectrum::BinaryData::MZ_ARRAY
            :mz_binary
          when ImzML::Spectrum::BinaryData::INTENSITY_ARRAY
            :intensity_binary
          end

          break if !@binary_type.nil?
        end

        # detect binary data type
        number_type = nil
        group.each do |param|
          number_type = case param[:accession]
          when Spectrum::BinaryData::BINARY_TYPE_8BIT_INTEGER
            :int8
          when Spectrum::BinaryData::BINARY_TYPE_16BIT_INTEGER
            :int16
          when Spectrum::BinaryData::BINARY_TYPE_32BIT_INTEGER
            :int32
          when Spectrum::BinaryData::BINARY_TYPE_64BIT_INTEGER
            :int64
          when Spectrum::BinaryData::BINARY_TYPE_32BIT_FLOAT
            :float32
          when Spectrum::BinaryData::BINARY_TYPE_64BIT_FLOAT
            :float64
          end

          break if !number_type.nil?
        end
        self.send("#{@binary_type.to_s}_data_type=", number_type) if !number_type.nil?
      end

      # save info about binary
      if name == :cvParam && @stack.last == :binaryDataArray
        spectrum = @metadata.spectrums[@elements[-3][:id].to_sym]

        # convert chosen type to mz_binary/intensity_binary property selector
        binary_data = spectrum.send(@binary_type.to_s)
        binary_data.filepath = binary_filepath
        binary_data.type = self.send("#{@binary_type}_data_type")
        case element[:accession]
        when ImzML::Spectrum::BinaryData::EXTERNAL_ARRAY_LENGTH
          binary_data.length = element[:value].to_i
        when ImzML::Spectrum::BinaryData::EXTERNAL_OFFSET
          binary_data.offset = element[:value].to_i
        when ImzML::Spectrum::BinaryData::EXTERNAL_ENCODED_LENGHT
          binary_data.encoded_length = element[:value].to_i
        end

      end

      # p @metadata.spectrums if name == :binaryDataArray

      # p "#{name} ended #{element}"

    end

  end

end