# hash = HashWithoutNilValues.new
# hash[:a] = nil
# hash # => {}
#
# hash[:a] = {}
# hash[:a].class # => HashWithoutNilValues
#
# hash[:a] = []
# hash[:a].class # => ArrayWithoutNilValues
#
# hash[:a] << nil
# hash[:a] # => []
#
# hash[:a] << {}
# hash[:a].first.class # => HashWithoutNilValues
#
class HashWithoutNilValues < Hash
  def []=(key, value)
    return if value.nil?
    value = HashWithoutNilValues.new if value == {}
    value = ArrayWithoutNilValues.new if value == []
    super(key, value)
  end
end

class ArrayWithoutNilValues < Array
  def <<(value)
    return if value.nil?
    value = ArrayWithoutNilValues.new if value == []
    value = HashWithoutNilValues.new if value == {}
    super(value)
  end
end
