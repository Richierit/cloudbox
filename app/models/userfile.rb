class Userfile < ActiveRecord::Base
	belongs_to :user
	validates :user, :presence => true
	validates :name, uniqueness: true
end
