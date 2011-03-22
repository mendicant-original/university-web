require 'test_helper'

class TermTest < ActiveSupport::TestCase
  context "validations" do
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
  end

  context "scopes" do
    setup do
      @term_2010 = Factory(:term,
                           :name => '2010jan',
                           :start_date => '2010-1-1'.to_date,
                           :end_date => '2010-1-31'.to_date)

      @term_2011 = Factory(:term,
                           :name => '2011_T1',
                           :start_date => '2011-1-1'.to_date,
                           :end_date => '2011-3-31'.to_date)

      @term_2010_2011 = Factory(:term,
                                :start_date => '2010-10-1'.to_date,
                                :end_date => '2011-6-30'.to_date)
    end

    test "per_year scope lists all terms starting the given year" do
      assert Term.per_year(2010).include?(@term_2010)
      assert Term.per_year(2010).include?(@term_2010_2011)
      assert !Term.per_year(2010).include?(@term_2011)

      assert Term.per_year(2011).include?(@term_2011)
      assert !Term.per_year(2011).include?(@term_2010)
      assert !Term.per_year(2011).include?(@term_2010_2011)
    end
  end

  context "alumni" do
    setup do
      @term_2010_jan      = Factory(:term,
                                   :start_date => '2010-1-1'.to_date,
                                   :end_date => '2010-1-31'.to_date)

      @term_2010_t1       = Factory(:term,
                                    :start_date => '2010-1-1'.to_date,
                                    :end_date => '2010-3-31'.to_date)

      @alumnus1           = Factory(:user,
                                    :alumni_number => 1,
                                    :alumni_year => 2010,
                                    :alumni_month => 1)

      @alumnus2           = Factory(:user,
                                    :alumni_number => 2,
                                    :alumni_year => 2010,
                                    :alumni_month => 2)
    end

    test "alumni list should contain all within its dates" do
      assert @term_2010_jan.alumni.include?(@alumnus1)
      assert !@term_2010_jan.alumni.include?(@alumnus2)

      assert @term_2010_t1.alumni.include?(@alumnus1)
      assert @term_2010_t1.alumni.include?(@alumnus2)
    end
  end

  private

  def valid_term_attributes
    { :name => "T1",
      :slug => "t1",
      :start_date => "2010-1-1".to_date,
      :end_date => "2010-3-31".to_date }
  end
end