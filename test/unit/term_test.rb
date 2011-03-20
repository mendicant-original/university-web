require 'test_helper'

class TermTest < ActiveSupport::TestCase
  test "requires a valid name" do
    term = Term.new(valid_term_attributes.except(:name))
    assert !term.valid?

    assert term.errors[:name]
  end

  test "requires an start date" do
    term = Term.new(valid_term_attributes.except(:start_date))
    assert !term.valid?

    assert term.errors[:start_date]
  end

  test "requires an end date" do
    term = Term.new(valid_term_attributes.except(:end_date))
    assert !term.valid?

    assert term.errors[:end_date]
  end

  test "requires an end date after the start date" do
    term = Term.new(valid_term_attributes.merge(:end_date => 10.years.ago))
    assert !term.valid?

    assert term.errors[:end_date]
  end

  test "end date can be equal to start date" do
    term = Term.new(valid_term_attributes.merge(:start_date => Time.now,
                                                :end_date => Time.now))
    assert term.valid?
  end

  private

  def valid_term_attributes
    { :name => "T1",
      :start_date => "2010-1-1".to_date,
      :end_date => "2010-3-31".to_date }
  end
end