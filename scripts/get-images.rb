#!/usr/bin/env ruby

require 'json'

if ARGV.length != 2
  puts "Usage: #{$0} <images-json-file> <output-folder>"
  exit 1
end

def main
  input_file = ARGV[0]
  output_folder = ARGV[1]

  file = File.read(input_file)

  imageUrls = JSON.parse(file).map { |json| json['image'] }

  imageUrls.each do |url|
    puts "Downloading: #{url}"
    out = "#{output_folder}/#{url.gsub(/https:\/\/uploads\d\.wikiart\.org\/.*images\//, '')}"
    basename = File.basename(out)
    `mkdir -p "#{out.gsub(basename, '')}"`
    `wget -nc "#{url}" -O "#{out}"`
  end
end

main
