class FileWriter

  def write(queue, filename, header_row)
    puts "In FileWriter::write method"

    Dir.mkdir("data") unless Dir.exists?("data")

    CSV.open("data/#{filename}", "w") do |csv|
      csv << header_row
      queue.each do |person|
        csv << write_row(person, header_row)
      end
    end
  end

  def write_row(person, header_row)
    row = header_row.collect do |field|
      person[field.to_sym.downcase]
    end
  end

end
