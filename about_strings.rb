require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutStrings < Neo::Koan
  def test_double_quoted_strings_are_strings
    str = "Hello, World"
    assert_equal true, str.is_a?(String)
  end

  def test_single_quoted_strings_are_also_strings
    string = 'Goodbye, World'
    assert_equal true, string.is_a?(String)
  end

  def test_use_single_quotes_to_create_string_with_double_quotes
    string = 'He said, "Go Away."'
    assert_equal true, string.is_a?(String)
  end

  def test_use_double_quotes_to_create_strings_with_single_quotes
    string = "Don't"
    assert_equal true, string.is_a?(String)
  end

  def test_use_backslash_for_those_hard_cases
    a = "He said, \"Don't\""
    b = 'He said, "Don\'t"'
    assert_equal true, a == b, "Backslashes to scape quotes"
  end

  def test_use_flexible_quoting_to_handle_really_hard_cases
    a = %(flexible quotes can handle both ' and " characters)
    b = %(flexible quotes can handle both ' and " characters)
    c = %(flexible quotes can handle both ' and " characters)
    assert_equal true, a == b, "Flexible quotes are great"
    assert_equal true, a == c, "Flexible quotes are great"
  end

  def test_flexible_quotes_can_handle_multiple_lines
    long_string = %(It was the best of times,
It was the worst of times.
)
    assert_equal 53, long_string.length, "What's the length of a multiple line string?"
    assert_equal 2, long_string.lines.count,
                 "\n is used as separator for lines"
    assert_equal "I", long_string[0, 1], "What's the first character of the string?"
  end

  def test_here_documents_can_also_handle_multiple_lines
    long_string = <<~EOS
      It was the best of times,
      It was the worst of times.
    EOS
    assert_equal 53, long_string.length, "Heredocs handle multiple lines"
    assert_equal 2, long_string.lines.count
    assert_equal "I", long_string[0, 1]
  end

  def test_plus_will_concatenate_two_strings
    string = 'Hello, ' + 'World'
    assert_equal "Hello, World", string, "Concatenation with +"
  end

  def test_plus_concatenation_will_leave_the_original_strings_unmodified
    hi = 'Hello, '
    there = 'World'
    string = hi + there
    assert_equal 'Hello, ', hi, "First string"
    assert_equal 'World', there, "Second string"
  end

  def test_plus_equals_will_concatenate_to_the_end_of_a_string
    hi = 'Hello, '
    there = 'World'
    hi += there
    assert_equal 'Hello, World', hi, "Strings' concatenation"
  end

  def test_plus_equals_also_will_leave_the_original_string_unmodified
    original_string = 'Hello, '
    hi = original_string
    there = 'World'
    hi += there
    assert_equal 'Hello, ', original_string, "String values are copies, not references"
  end

  def test_the_shovel_operator_will_also_append_content_to_a_string
    hi = 'Hello, '
    there = 'World'
    hi << there
    assert_equal "Hello, World", hi, "String is modified in place"
    assert_equal 'World', there, "The one appended is not modified"
  end

  def test_the_shovel_operator_modifies_the_original_string
    original_string = 'Hello, '
    hi = original_string
    there = 'World'
    hi << there
    assert_equal 'Hello, World', original_string, "Shovel operator modifies original_string"

    # THINK ABOUT IT:
    #
    # Ruby programmers tend to favor the shovel operator (<<) over the
    # plus equals operator (+=) when building up strings.  Why?
  end

  def test_double_quoted_string_interpret_escape_characters
    string = "\n"
    assert_equal 1, string.size, "This renders a new line"
  end

  def test_single_quoted_string_do_not_interpret_escape_characters
    string = '\n'
    assert_equal 2, string.size, "This doesn't interpret the escape character"
  end

  def test_single_quotes_sometimes_interpret_escape_characters
    string = '\\\''
    assert_equal 2, string.size, "size function interprets escape characters"
    assert_equal '\\\'', string, "string is printed literally"
  end

  def test_double_quoted_strings_interpolate_variables
    value = 123
    string = "The value is #{value}"
    assert_equal "The value is 123", string, "I love interpolation"
  end

  def test_single_quoted_strings_do_not_interpolate
    value = 123
    string = 'The value is #{value}'
    assert_equal 'The value is #{value}', string,
                 "again, single quotes doesn't interpret their content"
  end

  def test_any_ruby_expression_may_be_interpolated
    string = "The square root of 5 is #{Math.sqrt(5)}"
    assert_equal "The square root of 5 is 2.23606797749979", string,
                 "expression are evaluation within the interpolation"
  end

  def test_you_can_get_a_substring_from_a_string
    string = 'Bacon, lettuce and tomato'
    assert_equal 'let', string[7, 3], 'from index take n characters'
    assert_equal 'let', string[7..9], 'ranges work too'
  end

  def test_you_can_get_a_single_character_from_a_string
    string = 'Bacon, lettuce and tomato'
    assert_equal 'a', string[1], 'string indexes start at 0'

    # Surprised?
  end

  in_ruby_version('1.8') do
    def test_in_older_ruby_single_characters_are_represented_by_integers
      assert_equal __, 'a'
      assert_equal __, 'a' == 97

      assert_equal __, 'b' == ('a' + 1)
    end
  end

  in_ruby_version('1.9', '2', '3') do
    def test_in_modern_ruby_single_characters_are_represented_by_strings
      assert_equal "a", 'a'
      assert_equal false, 'a' == 97, "not an ASCII code"
    end
  end

  def test_strings_can_be_split
    string = 'Sausage Egg Cheese'
    words = string.split
    assert_equal [string[0..6], string[8..10], string[12..]], words
  end

  def test_strings_can_be_split_with_different_patterns
    string = 'the:rain:in:spain'
    words = string.split(/:/)
    assert_equal [words[0], words[1], words[2], words[3]], words

    # NOTE: Patterns are formed from Regular Expressions.  Ruby has a
    # very powerful Regular Expression library.  We will become
    # enlightened about them soon.
  end

  def test_strings_can_be_joined
    words = %w[Now is the time]
    assert_equal 'Now is the time', words.join(' ')
  end

  def test_strings_are_unique_objects
    a = 'a string'
    b = 'a string'

    assert_equal true, a == b
    assert_equal false, a.equal?(b)
  end
end
