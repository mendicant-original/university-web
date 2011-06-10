module Github
  class GithubCommit

    attr_reader :id, :login, :commit_time, :message

    def initialize(hash)
      @id           = hash[:id]
      @login        = hash[:committer][:login]
      @commit_time  = Time.parse(hash[:committed_date])
      @message      = hash[:message]
    end

    def to_s
      @message
    end

  end
end