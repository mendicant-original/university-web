class Chat::MessagePresenter
  include Enumerable

  def initialize(messages)
    @messages = messages.map { |m| Message.new(m) }
    group_by_name
  end

  def group_by_name
    previous = nil

    @messages.each do |message|
      if previous && message.name == previous
        message.clear_display_name
      end
      previous = message.name
    end
  end

  def last
    @messages.last
  end

  def last_message_recorded_at
  end

  def last_message_id
  end

  def each(&block)
    @messages.each(&block)
  end

  class Message
    attr_reader :id, :display_name, :name, :body, :recorded_at

    def initialize(message)
      @message = message
      @id = message.id
      @name = message.handle.name
      @display_name = @name.dup
      @body = message.body
      @recorded_at = message.recorded_at
    end

    def clear_display_name
      @display_name = nil
    end

    def action?
      @message.action?
    end

    # From helper module
    def message_date
    end
  end
end
