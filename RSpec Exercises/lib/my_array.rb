class Array
  def my_uniq
    uniq_array = []
    self.each do |item|
      uniq_array << item unless uniq_array.include?(item)
    end
    uniq_array
  end

  def two_sum
    pairs = []
    self.each_with_index do |item1, i1|
      self.each_with_index do |item2, i2|
        next if i2 <= i1
        pairs << [i1,i2] if item1 + item2 == 0
      end
    end

    pairs
  end
end