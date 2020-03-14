class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.is_admin?
      can :manage, :all
    elsif user.is_business?
      can :read,    User
      can :update,  User, id: user.id
      can :destroy, User, id: user.id
      can :serve_small, User
      can :serve_medium, User
      can :serve_large, User

      can :read, Status
      can :read, Priority
      can :read, Vertical
      can :read, RequestType

      can :read,    Comment
      can :create,  Comment
      can :update,  Comment, user: user
      can :destroy, Comment, user: user

      can :read,    Task
      can :create,  Task
      can :update,  Task
      can :destroy, Task, reported_by: user

      can :manage, Attachment
    else
      can :create, User
    end
  end
end
