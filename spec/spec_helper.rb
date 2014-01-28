require 'simplecov'
SimpleCov.start

SimpleCov.add_filter do |src_file|
	File.basename(src_file.filename, '.rb').include? 'spec'
end
