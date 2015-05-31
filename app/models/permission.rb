# class OwnerValidator < ActiveModel::Validator
#   def validate(permission)
#   	# file = Userfile.where(id: file_id)
# 	# if file.user_id != current_user.id
#  #      permission.errors[:base] << "You don't own the file"
#  #    end
#   end
# end

class Permission < ActiveRecord::Base
	validates :sharer, :presence => true
	validates :file_id, :presence => true 
	validates :sharedto, :presence => true
	# validates_with OwnerValidator
	belongs_to :user
	before_save :check_owner
	def check_owner
		# raise "#{file_id}"
		# current_user = @user.id
		file = Userfile.where(id: file_id)
		owner = User.where(id: file[0].user_id)
		owner = owner[0].email
		# raise "#{sharer},#{owner}"
		if sharer != owner
	        return false
	    end
	end
end

