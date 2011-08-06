# From https://github.com/citrusbyte/contest/blob/master/lib/contest.rb

module MiniContest

  def setup(&block)
    define_method :setup do
      super(&block)
      instance_eval(&block)
    end
  end

  def teardown(&block)
    define_method :teardown do
      instance_eval(&block)
      super(&block)
    end
  end

  def context(*name, &block)
    subclass = Class.new(self)
    remove_tests(subclass)
    subclass.class_eval(&block) if block_given?
    const_set(context_name(name.join(" ")), subclass)
  end

  def test(name, &block)
    define_method(test_name(name), &block)
  end

  private

  def context_name(name)
    "Test#{sanitize_name(name).gsub(/(^| )(\w)/) { $2.upcase }}".to_sym
  end

  def test_name(name)
    "test_#{sanitize_name(name).gsub(/\s+/,'_')}".to_sym
  end

  def sanitize_name(name)
    name.gsub(/\W+/, ' ').strip
  end

  def remove_tests(subclass)
    subclass.public_instance_methods.grep(/^test_/).each do |meth|
      subclass.send(:undef_method, meth.to_sym)
    end
  end
end

class MiniTest::Unit::TestCase
  extend MiniContest
end