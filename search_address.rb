
require 'csv'

INDEX_DATA_DIR = 'index_data'
ADDRESS_DATA_FILE = 'address_data.csv'


print 'search words => '
input = gets.chomp#.gsub(/\s/, '')

index_array_list = []

input.chars.uniq.each do |char|
  file_name = "./#{INDEX_DATA_DIR}/#{char}.csv"
  index_array_list << CSV.read(file_name).first.map(&:to_i)
end

address_line_no_list = index_array_list.inject(:'&')

if address_line_no_list.nil? || address_line_no_list.empty?
  puts "Not Found."
  exit(0)
end

target_line_no = address_line_no_list.shift

open(ADDRESS_DATA_FILE, 'r') do |f|
  f.each_line do |line|
    line_no = $.
    next if line_no != target_line_no

    puts line

    target_line_no = address_line_no_list.shift
    break unless target_line_no
  end
end
