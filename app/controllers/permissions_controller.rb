class PermissionsController < ApplicationController
	def create
	  	# raise "#{params}"
	  	# raise "#{params[:permission]}"
	  	respond_to do |format|
		  	@permission = Permission.new
		  	@permission.sharer = current_user.email
		  	@permission.file_id = params[:permission][:file_id]
		  	@permission.sharedto = params[:permission][:sharedto]
	  		# raise "#{params}"
	  		# raise "#{@permission.sharer}, #{@permission.file_id}, #{@permission.sharedto}"
			if @permission.save
				format.html { redirect_to root_path, notice: 'File was successfully shared.' }
				# format.json { render :show, status: :created, location: @user }
			else
				format.html { redirect_to root_path, notice: 'File was not shared. You do not own the file' }
				format.json { render json: @permission.errors, status: :unprocessable_entity }
			end
	    end
	end
end
