require "./hexed/*"

if ARGV.size < 1
  puts "Usage: #{PROGRAM_NAME} <filename>"
  exit 1
end

filename = ARGV[0]
length = File.size(filename)
data = Bytes.new(length)
File.open(filename, "rb") do |file|
  file.read_fully data
end

ui = Hexed::UI.new(data, aligned = true, offset = 0)
ui.run
