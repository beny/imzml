module ImzML

  class Spectrum

    class BinaryData

      # Binary data types, always little endian
      BINARY_TYPE_8BIT_INTEGER = "IMS:1100000"
      BINARY_TYPE_16BIT_INTEGER = "IMS:1100001"
      BINARY_TYPE_32BIT_INTEGER = "MS:1000519"
      BINARY_TYPE_64BIT_INTEGER = "MS:1000522"
      BINARY_TYPE_32BIT_FLOAT = "MS:1000521"
      BINARY_TYPE_64BIT_FLOAT = "MS:1000523"

      # A data array of m/z values
      MZ_ARRAY = "MS:1000514"

      # A data array of intensity values
      INTENSITY_ARRAY = "MS:1000515"

      # Describes how many fields an array contains
      attr_accessor :length
      EXTERNAL_ARRAY_LENGTH = "IMS:1000103"

      # The position where the data of an array of a mass spectrum begins
      attr_accessor :offset
      EXTERNAL_OFFSET = "IMS:1000102"

      # Describes the length of the written data
      attr_accessor :encoded_length
      EXTERNAL_ENCODED_LENGHT = "IMS:1000104"

      # Path to the external binary file
      attr_accessor :filepath

      # Binary values type [:int8, :int16, :int32, :int64, :float32, :float64]
      attr_accessor :type

      # grabs the actual binary data from disk
      def data(cached = true)

        # Return the data from the cache
        return @cached_data if cached && !@cached_data.nil?

        # Remove possible data from the cache
        @cached_data = nil

        # Switch binary pattern reading type
        pattern = case type
        when :int8
          "C"
        when :int16
          "S"
        when :int32
          "L"
        when :int64
          "Q"
        when :float32
          "e"
        when :float64
          "E"
        end

        # Read data based on metadata
        data = IO.binread(@filepath, @encoded_length.to_i, @offset.to_i).unpack("#{pattern}*")

        # Save data only if user want's to cache it, saving take some CPU
        @cached_data = data if cached
      end

      private

      attr_accessor :cached_data

    end

    # Attributes to describe the position of a spectrum in the image.
    #
    # represented as Point with position x, y
    attr_accessor :position
    POSITION_X = "IMS:1000050"
    POSITION_Y = "IMS:1000051"

    # Info about mz binary data
    #
    # Represented by class BinaryData
    attr_accessor :mz_binary

    # Info about intensity binary data
    #
    # Represented by class BinaryData
    attr_accessor :intensity_binary

    def intensity(at, interval)

      # read whole the binary data
      mz_array = mz_binary.data
      intensity_array = intensity_binary.data

      default_from, default_to = mz_array.first, mz_array.first

      from = default_from
      to = default_to

      # find designated intensity
      if at
        from = at - interval
        from = default_from if from < 0
        to = at + interval
        to = default_to if to > mz_array.last
      end

      # find values in mz array
      low_value = mz_array.bsearch { |x| x >= from }
      low_index = mz_array.index(low_value)
      high_value = mz_array.bsearch { |x| x >= to }
      high_index = mz_array.index(high_value)

      # sum all values in subarray
      sum = intensity_array[low_index..high_index].inject{|sum, x| sum + x}

      sum
    end


  end

end