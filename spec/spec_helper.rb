require 'simplecov'
SimpleCov.start

SimpleCov.add_filter do |src_file|
	File.basename(src_file.filename, '.rb').include? 'spec'
end

require_relative '../lib/setup'
require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/human_player'
require_relative '../lib/computer_player'
include Setup
