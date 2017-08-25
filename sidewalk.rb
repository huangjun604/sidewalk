# A representation of our sidewalk
SIDEWALK = 0..1

# Implement this function. It should accept a random Range that represents the
# raindrop falling onto the SIDEWALK. After letting this raindrop "hit" the
# sidewalk, it should return true if a drop has hit every point on the sidewalk,
# false otherwise.
#
# Example:
#
#   SIDEWALK = 0.0..1.0
#
#   all_wet_after_drop?(0.0..0.456)
#   => false

#   all_wet_after_drop?(0.123..0.789)
#   => false

#   all_wet_after_drop?(0.567..0.999)
#   => false

#   all_wet_after_drop?(0.789..1.234)
#   => true
#
# @param drop [Range] the raindrop
#
# @return [TrueClass|FalseClass] is the sidewalk wet everywhere?
def all_wet_after_drop?(drop)
  @drops = @drops ? @drops << drop : [drop]
  @drops = sort @drops
  @drops = merge @drops
  fullcover? @drops
end

# Sort the drops by the beginning of the range.
#
# @param drops [[Range]] the list of raindrops
#
# @return [[Range]] the sorted list of raindrops
def sort(drops)
  drops.sort_by(&:first)
end

# Merge the drops if the neighbouring drops have the overlaping
#
# @param drops [[Range]] the list of raindrops
#
# @return [[Range]] the sorted list of raindrops
def merge(drops)
  1.upto(drops.length-1) do |i|
    drops[i-1], drops[i] = combine drops[i-1], drops[i]
  end
  drops.compact
end

# Combine two drops if they are overlap. Return a pair of drops if not overlapping,
# otherwise return a pair of [nil, combined drop]
#
# @param a [Range] a range
# @param b [Range] other range
#
# @return [Range, Range] the pair of two ranges, first item could be nil if combined
def combine(a, b)
  a.last < b.first ? [a, b] : [nil, a.first..[a.last, b.last].max]
end

# Check the drops if hit every point of the sidewalk
#
# @param drops [[Range]] the list of merged raindrops
#
# @return [TrueClass|FalseClass] Return true if full covered, otherwise return false
def fullcover?(drops)
  return false if drops.length > 1
  drops.first.cover?(SIDEWALK.first) && drops.first.cover?(SIDEWALK.last) ? true : false
end

# Generate a random randrop that starts within SIDEWALK and
# has a length between 0 and 0.1
def random_drop
  prng = Random.new
  start = prng.rand(SIDEWALK.begin.to_f..SIDEWALK.end.to_f)
  width = prng.rand(0.0001..0.1)

  start..(start+width)
end

# NO INFINITE LOOP
loop do
  break if all_wet_after_drop?(random_drop)
end
