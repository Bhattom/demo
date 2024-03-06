class User < ApplicationRecord
    
    acts_as_paranoid
    validates :email, uniqueness: true
    paginates_per 3
    require 'csv'



    def self.ransackable_attributes(_auth_object)
      ["name", "email", "login"]
    end

    def self.ransackable_associations(auth_object = nil)
      []
    end 

    def run
        User.find_each do |user|
          UserMailer.with(user: user).deliver_later
        end
    end

    def welcome_email(user)
        attachments.inline['images.jpeg'] = File.read('apps/assets/images/images.jpeg')
      end
    
      def self.to_csv
      users = all
      column_names = %w(id name email login)
      CSV.generate do |csv|
        csv << column_names
        users.each do |user|
          csv << user.attributes.values_at(*column_names)
        end
      end
      end
end
