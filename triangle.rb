# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#
# def triangle_old(a, b, c)
#   if a == b && b == c # if: +1, &&: +1 (3)
#     :equilateral
#   elsif ((a == b || a == c) && b != c) || (a != b && b == c) # ||: +2, &&: +2, (7)
#     :isosceles
#   else
#     :scalene
#   end
# end

# def triangle(a, b, c)
#   if a == b # +1 (2)
#     c == b ? :equilateral : :isosceles # +1 (3)
#   elsif b == c || a == c # if: +1, ||: +1 (5)
#     :isosceles
#   else
#     :scalene
#   end
# end

def valid?(a, b, c)
  sides = [a, b, c].sort!
  raise TriangleError, 'Negative sides not allowed.' if sides.min <= 0
  raise TriangleError, 'Triangle inequality not met.' if sides[0] + sides[1] <= sides[2]
end

def triangle(a, b, c)
  valid?(a, b, c)
  distinct_sides = [a, b, c].uniq.length - 1
  %i[equilateral isosceles scalene][distinct_sides]
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
