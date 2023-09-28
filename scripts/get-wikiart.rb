#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'

if ARGV.empty? || ARGV.length != 4
  puts "Usage: #{$0} <file> <output> <limit> <from>"
  exit
end

def read_links(filename)
  file = File.read(filename)
  file.split("\n")
end

def fetch(link)
  puts "Fetching: #{link}"
  uri = URI.parse(link)
  response = Net::HTTP.get_response(uri)

  require 'pry'; binding.pry if response.code != '200'

  response.body
end

def paintingJson(body)
  require 'pry'; binding.pry if body.nil?

  raw = body
    .split("\n")
    .find { |line| line.include? 'class="wiki-layout-painting-info-bottom"' }
    .split('ng-init="paintingJson = ')[1]
    .split('">')[0]
    .gsub('&quot;', '"')

  JSON.parse(raw)
    .select { |k, v| ['title', 'year', 'artistName', 'image'].include? k }
end

def write_jsons(jsons)
  File.open(ARGV[1],"w") { |f| f.write(JSON.pretty_generate(jsons)) }
end

def main
  links = read_links(ARGV[0])
  jsons = links.slice(ARGV[3].to_i, ARGV[2].to_i)
    .map { |link| fetch(link) }
    .map { |body| paintingJson(body) }

  write_jsons(jsons)
end

main
