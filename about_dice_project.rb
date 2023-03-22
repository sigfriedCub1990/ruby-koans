require File.expand_path(File.dirname(__FILE__) + '/neo')

# Implement a DiceSet Class here:
#
class DiceSet
  attr_reader :values

  def initialize
    @values = []
  end

  def roll(rolls)
    new_values = []
    rolls.times do
      new_values << rand(1..6)
    end
    @values = new_values
  end
end

class AboutDiceProject < Neo::Koan
  def test_can_create_a_dice_set
    current_dice = DiceSet.new
    assert_not_nil current_dice
  end

  def test_rolling_the_dice_returns_a_set_of_integers_between_1_and_6
    current_dice = DiceSet.new # {{{

    current_dice.roll(5)
    assert current_dice.values.is_a?(Array), "should be an array"
    assert_equal 5, current_dice.values.size
    current_dice.values.each do |value|
      assert value >= 1 && value <= 6, "value #{value} must be between 1 and 6"
    end # }}}
  end

  def test_dice_values_do_not_change_unless_explicitly_rolled
    current_dice = DiceSet.new # {{{
    current_dice.roll(5)
    first_time = current_dice.values
    second_time = current_dice.values
    assert_equal first_time, second_time # }}}
  end

  def test_dice_values_should_change_between_rolls
    current_dice = DiceSet.new

    current_dice.roll(5)
    first_time = current_dice.values

    current_dice.roll(5)
    second_time = current_dice.values

    assert_not_equal [first_time, first_time.object_id], [second_time, second_time.object_id],
                     "Two rolls should not be equal"

    # THINK ABOUT IT:
    #
    # If the rolls are random, then it is possible (although not
    # likely) that two consecutive rolls are equal.  What would be a
    # better way to test this?
    #
    # https://stackoverflow.com/questions/2082970/whats-the-best-way-to-test-this
  end

  def test_you_can_roll_different_numbers_of_dice
    current_dice = DiceSet.new # {{{

    current_dice.roll(3)
    assert_equal 3, current_dice.values.size

    current_dice.roll(1)
    assert_equal 1, current_dice.values.size # }}}
  end
end
