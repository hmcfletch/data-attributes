module DataAttributes
  class DataAttributeError < StandardError
  end

  class NonSerializedColumnError < DataAttributeError
  end

  class NonDataAttributeError < DataAttributeError
  end
end
