authorization do

  role :guest do
    has_permission_on :challenges, to: :read
    has_permission_on :sessions, to: [:create, :destroy]
  end

  role :user do
    includes :guest

    has_permission_on :challenges, to: :manage
    has_permission_on :participations, to: :manage do
      if_attribute :user_id => is  { user.id }
    end
  end

  role :admin do
    includes :guest
    includes :user

    has_permission_on [
      :challenges,
      :participations], to: :manage
  end

end

privileges do
  privilege :manage, :includes => [:read, :create, :update, :delete]
  privilege :read,   :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end