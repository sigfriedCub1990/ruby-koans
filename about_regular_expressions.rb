# -*- coding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutRegularExpressions < Neo::Koan
  def test_a_pattern_is_a_regular_expression
    assert_equal Regexp, /pattern/.class
  end

  def test_a_regexp_can_search_a_string_for_matching_content
    assert_equal 'match', "some matching content"[/match/]
  end

  def test_a_failed_match_returns_nil
    assert_equal nil, "some matching content"[/missing/]
  end

  # ------------------------------------------------------------------

  def test_question_mark_means_optional
    assert_equal 'ab', "abbcccddddeeeee"[/ab?/]
    assert_equal 'a', "abbcccddddeeeee"[/az?/]
  end

  def test_plus_means_one_or_more
    assert_equal 'bccc', "abbcccddddeeeee"[/bc+/]
  end

  def test_asterisk_means_zero_or_more
    assert_equal 'abb', "abbcccddddeeeee"[/ab*/]
    assert_equal 'a', "abbcccddddeeeee"[/az*/]
    # puts "The result is: #{'ab'[/xz*/].inspect}"
    assert_equal '', "abbcccddddeeeee"[/z*/], "no matching with * returns empty string"

    # THINK ABOUT IT:
    #
    # When would * fail to match?
    #
    # TODO: Don't know, but I'll figure it out later.
  end

  # THINK ABOUT IT:
  #
  # We say that the repetition operators above are "greedy."
  #
  # Why?
  #
  # Because they take as much characters as they can, in contrast to lazy operators that
  # only need a few characters to match in order for the Regex to succeed.
  # https://docs.ruby-lang.org/en/master/Regexp.html#class-Regexp-label-Greedy+Match

  # ------------------------------------------------------------------

  def test_the_left_most_match_wins
    assert_equal 'a', "abbccc az"[/az*/], 'the first occurence of the pattern is the output'
  end

  # ------------------------------------------------------------------

  def test_character_classes_give_options_for_a_character
    animals = %w[cat bat rat zat]
    assert_equal %w[cat bat rat], (animals.select { |a| a[/[cbr]at/] }) # Per Rubocop suggestion
  end

  def test_slash_d_is_a_shortcut_for_a_digit_character_class
    assert_equal "42", "the number is 42"[/[[:digit:]]+/] # Or /[0..9]/+ as it was initally
    assert_equal "42", "the number is 42"[/\d+/], 'with a character class'
  end

  def test_character_classes_can_include_ranges
    assert_equal "42", "the number is 42"[/[0-9]+/]
  end

  def test_slash_s_is_a_shortcut_for_a_whitespace_character_class
    assert_equal " \t\n", "space: \t\n"[/\s+/]
  end

  def test_slash_w_is_a_shortcut_for_a_word_character_class
    # NOTE:  This is more like how a programmer might define a word.
    assert_equal 'variable_1', "variable_1 = 42"[/[a-zA-Z0-9_]+/]
    assert_equal 'variable_1', "variable_1 = 42"[/\w+/]
  end

  def test_period_is_a_shortcut_for_any_non_newline_character
    assert_equal 'abc', "abc\n123"[/a.+/]
  end

  def test_a_character_class_can_be_negated
    assert_equal 'the number is ', "the number is 42"[/[^0-9]+/]
  end

  def test_shortcut_character_classes_are_negated_with_capitals
    assert_equal 'the number is ', "the number is 42"[/\D+/]
    assert_equal 'space:', "space: \t\n"[/\S+/]
    # ... a programmer would most likely do
    assert_equal ' = ', "variable_1 = 42"[/[^a-zA-Z0-9_]+/]
    assert_equal ' = ', "variable_1 = 42"[/\W+/]
  end

  # ------------------------------------------------------------------

  def test_slash_a_anchors_to_the_start_of_the_string
    assert_equal 'start', "start end"[/\Astart/]
    assert_equal nil, "start end"[/\Aend/]
  end

  def test_slash_z_anchors_to_the_end_of_the_string
    assert_equal 'end', "start end"[/end\z/]
    assert_equal nil, "start end"[/start\z/]
  end

  def test_caret_anchors_to_the_start_of_lines
    assert_equal '2', "num 42\n2 lines"[/^\d+/]
  end

  def test_dollar_sign_anchors_to_the_end_of_lines
    assert_equal '42', "2 lines\nnum 42"[/\d+$/]
  end

  def test_slash_b_anchors_to_a_word_boundary
    assert_equal 'vines', "bovine vines"[/\bvine./]
  end

  # ------------------------------------------------------------------

  def test_parentheses_group_contents
    assert_equal 'hahaha', "ahahaha"[/(ha)+/]
  end

  # ------------------------------------------------------------------

  def test_parentheses_also_capture_matched_content_by_number
    assert_equal 'Gray', "Gray, James"[/(\w+), (\w+)/, 1]
    assert_equal 'James', "Gray, James"[/(\w+), (\w+)/, 2]
  end

  def test_variables_can_also_be_used_to_access_captures
    assert_equal 'Gray, James', "Name:  Gray, James"[/(\w+), (\w+)/]
    assert_equal 'Gray', ::Regexp.last_match(1)
    assert_equal 'James', ::Regexp.last_match(2)
  end

  # ------------------------------------------------------------------

  def test_a_vertical_pipe_means_or
    grays = /(James|Dana|Summer) Gray/
    assert_equal 'James Gray', "James Gray"[grays]
    assert_equal 'Summer', "Summer Gray"[grays, 1]
    assert_equal nil, "Jim Gray"[grays, 1]
  end

  # THINK ABOUT IT:
  #
  # Explain the difference between a character class ([...]) and alternation (|).
  #
  # Seems like the results will be the same,
  # I'm drawing my conclusions from:
  #   1. https://stackoverflow.com/questions/4724588/using-alternation-or-character-class-for-single-character-matching
  #   2. https://docs.ruby-lang.org/en/master/Regexp.html#class-Regexp-label-Character+Classes
  # Notice in 2 that it states: "... /[ab]/ means a or b,..."
  #
  # One advantage I see is that you can specify a literal pattern, as in /(James|Dana|Summer) Gray/
  # ------------------------------------------------------------------

  def test_scan_is_like_find_all
    assert_equal %w[one two three], "one two-three".scan(/\w+/)
  end

  def test_sub_is_like_find_and_replace
    assert_equal 'one t-three', "one two-three".sub(/(t\w*)/) { ::Regexp.last_match(1)[0, 1] }
  end

  def test_gsub_is_like_find_and_replace_all
    assert_equal 'one t-t', "one two-three".gsub(/(t\w*)/) {
                              ::Regexp.last_match(1)[0, 1]
                            }, 'g stands for Global'
  end
end
