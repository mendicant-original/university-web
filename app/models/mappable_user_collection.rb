#
# transform a collection of users into JSON data for the alumni map
#
class MappableUserCollection
  def initialize(users)
    @users = users
  end

  def to_json
    @users.inject({}) do |h, user|
      key = "#{ '%.5f' % user.latitude },#{ '%.5f' % user.longitude }"
      h[key] ||= []
      h[key] << user.id
      h

    end.to_json
  end
end
