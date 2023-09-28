#!/usr/bin/env ruby

require 'mini_magick'

input_folder = './images/'
output_folder = './thumbs/'

Dir.glob("#{input_folder}**/*.jpg").each do |image_path|
  image = MiniMagick::Image.open(image_path)
  image.resize "600x"

  output_path = image_path.sub(input_folder, output_folder)
  FileUtils.mkdir_p(File.dirname(output_path))

  image.write output_path
end
