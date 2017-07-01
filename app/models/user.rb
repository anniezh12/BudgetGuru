class User < ActiveRecord::Base

    has_secure_password
    has_many :accounts

    def slug
      self.username.downcase.gsub(" ", "-")
    end

    def self.find_by_slug(param)
      User.all.find{|s| s.slug == param}
    end

end
