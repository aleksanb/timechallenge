ALLOW_ROLE_TESTING = false

module Authorization
  def self.activate_authorization_rules_browser?
    ALLOW_ROLE_TESTING and Rails.env.development?
  end
end
