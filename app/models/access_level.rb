require "set"

class AccessLevel
  User   = Class.new(self)
  Course = Class.new(self)

  def self.definitions
    @definitions ||= Hash.new
  end

  def self.define(level, options={})
    definitions[level] = new(level, options)
  end

  def self.[](level)
    definitions[level]
  end

  def self.find_by_permission(permission)
    definitions.select { |k,v| v.allows?(permission) }.map { |k,_| k }
  end

  def initialize(name, options)
    @name        = name
    @permissions = options[:permissions]
    @parent      = options[:parent]
  end

  attr_reader :parent

  def permissions
    return @permissions unless parent

    @permissions + self.class[parent].permissions
  end

  def allows?(permission)
    permissions.include?(permission)
  end

  def to_s
    @name
  end

end
