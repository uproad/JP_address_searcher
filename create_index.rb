
require 'csv'
require 'fileutils'
require 'time'

CSV_FILE = 'KEN_ALL_UTF8.CSV'

ADDRESS_DATA_FILE = 'address_data.csv'

INDEX_DATA_DIR = 'index_data'

COLUMN_POST_CODE = 2
COLUMN_PREFUCTURE = 6
COLUMN_CITY = 7
COLUMN_BLOCK = 8

def print_log(message)
  print "\r[#{Time.now.strftime('%Y/%m/%d %H:%M:%S.%3N')}] #{message}"
end

def log(message)
  puts "[#{Time.now.strftime('%Y/%m/%d %H:%M:%S.%3N')}] #{message}"
end

def flush_index(index_hash)
  index_hash.each do |k,v|
    file_name = "./#{INDEX_DATA_DIR}/#{k}.csv"
    
    flg = true if File.exist?(file_name)

    FileUtils.touch(file_name) unless flg

    open(file_name,'a') do |f|
      f.print ',' if flg
      f.print v.join(',')
    end
  end
end

start_at = Time.now

log "Start"
log "Elase old index data"

FileUtils.rm_rf(INDEX_DATA_DIR)
FileUtils.mkdir_p(INDEX_DATA_DIR)

log 'Load original data...'

line_no = 0
address_list = []
continue_flg = false
continue_block = nil

open(ADDRESS_DATA_FILE,'w') do |f|
  print_log "Process => #{line_no}"
  CSV.foreach(CSV_FILE) do |row|
    line_no += 1

    post_code = row[COLUMN_POST_CODE]
    prefucture = row[COLUMN_PREFUCTURE]
    city =  row[COLUMN_CITY]
    block = row[COLUMN_BLOCK]

    if block.include?('（') && !block.include?('）')
      continue_flg = true
      continue_block = block
    else
      if continue_flg
        if block.include?('）')
          continue_flg = false
          f.puts "\"#{post_code}\",\"#{prefucture}\",\"#{city}\",\"#{continue_block + block}\""
          address_list << prefucture + city + continue_block + block
        else
          continue_block += block
        end
      else
        address_list << prefucture + city + block
        f.puts "\"#{post_code}\",\"#{prefucture}\",\"#{city}\",\"#{block}\""
      end
    end

    print_log "Process => #{line_no}" if line_no % 111 == 0
  end
end

print_log "Complete => #{line_no}\n"

log 'Create address master file.'


log "Complete."

line_size = address_list.size

log "Create index data."

index = {}
line_no = 0
print_log "Process => #{line_no}"

address_list.each do |str|
  line_no += 1

  str.chars.uniq.each do |c|
    index[c] ||= []
    index[c] << line_no
  end

  if line_no % 10000 == 0
    print_log "Process => #{line_no}"
    flush_index(index)
    index.clear
  end
end

print_log "Complete => #{line_no}\n"
flush_index(index)
index.clear

log "Time => #{Time.now - start_at}"
log "Finish."

