class Result
  attr_accessor :description, :content, :link
  def initialize(options)
    @description = options[:description]
    @content = options[:content]
    @link = options[:link]
  end
end