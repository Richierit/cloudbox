class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
	before_action :conns3



	def home
	end
	def conns3
		@bucket_name = 'bucket_name'
		@s3 = Aws::S3::Client.new
		@s3r = Aws::S3::Resource.new
		@bucket_resource = @s3r.bucket(@bucket_name)
		@objects = @s3.list_objects(bucket: @bucket_name).contents
		object_name
	end
	def object_name
		object_name_list = []
		i = 0
		@objects.each_with_index do |obj, index|
			key = obj.key
			size = obj.size
			object_name_list.insert(index, key)
		end
		object_data(object_name_list)
	end
	def object_data(object_name_list)
		@object_type = []
		@object_link = []
		@object_size = []
		object_name_list.each_with_index do |name, index|
			@object_type.insert(index, @bucket_resource.object(name).content_type)
			@object_link.insert(index, @bucket_resource.object(name).public_url)
			@object_size.insert(index, cal_byte(@bucket_resource.object(name).content_length))
		end
	end
	def bucketfile
		@total_size = 0
		@total_size = cal_totalsize(@objects)
		@total_size = cal_byte(@total_size)
	end
	def cal_totalsize(objects)
		total_size = 0
		@objects.each do |object|
			total_size = total_size + object.size
		end
		return total_size
	end
	def cal_byte(size)
		kb = 1024.00
		mb = kb * 1024.00
		if size < mb then
			if size < kb then 
				size = size.round(2)
				return "#{size} byte"
			else
				size = size / kb
				size = size.round(2)
				return "#{size} kb"
			end
		else
			size = size / mb
			size = size.round(2)
			return "#{size} mb"
		end
	end
end
