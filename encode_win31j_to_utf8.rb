
in_path = ARGV[0]

right_name = File.basename(in_path, '.*')
right_name += '_UTF8'

left_name = File.extname(in_path)

out_path = right_name + left_name

fo = File.open(out_path,'w')

File.open(in_path,'r') do |fi|
  fi.each_line do |line|
    fo.puts line.chomp.encode('utf-8','windows-31j')
  end
end

fo.close

