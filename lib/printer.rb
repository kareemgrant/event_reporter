require 'yaml'

class Printer

  FIELDS = {
            :Last_name => 9,
            :First_name => 10,
            :Email_address => 13,
            :Zipcode => 10,
            :City => 4,
            :State => 5,
            :Street => 6,
            :Homephone => 9,
          }

  GUTTER = 2

  def border_line
    puts "-"*180
  end

  def help_header
    puts ""
    border_line
    print "Command".ljust(45)
    print "Description".ljust(20) + "\n"
    border_line
  end

  def print_commands(command)

    yml = YAML.load_file('lib/help.yml')

    help_header

    if command == ""
      yml.each_pair do |key, value|
        puts value
      end
    else
      puts yml[command]
    end

    border_line
  end


  def print_queue(queue)

    col_widths = get_column_widths(FIELDS, queue)
    print_results_header(col_widths)

    count = 0
    q_size = queue.size

    display_results(queue, col_widths, count, q_size)
  end

  def display_results(queue, col_widths, count, q_size)
    queue.each do |person|
      if (count != 0) && (count % 10 == 0)
        puts "Displaying records #{count - 10} - #{count} of #{q_size}"
        input = ""
        while input != "\n"
          puts "press the enter key to show the next set of records"
          input = gets
        end
      end
      print_row(col_widths, person)
      count += 1
    end
  end

  def print_row(col_widths, person)
    col_widths.each do |field, value|
      if field == :homephone
        print person[field].ljust(value + GUTTER) + "\n"
      else
        print person[field].ljust(value + GUTTER)
      end
    end
  end


  def get_column_widths(fields, queue)

    col_widths = fields.inject({}) do |memo_hash, (name, width)|

      header_width = get_header_width(name)
      col_width = widest_col_width(queue, name.downcase)

      if col_width > header_width
        memo_hash[name.downcase] = col_width
      else
        memo_hash[name.downcase] = header_width
      end
      memo_hash
    end
  end

  def widest_col_width(queue, field)
    array = queue.collect do |person|
      person[field].length
    end
    array.max
  end

  def get_header_width(field)
    FIELDS[field]
  end

   def print_results_header(col_widths)
      puts ""
      border_line
      col_widths.each do |field, value|
      if field == :homephone
        print field.to_s.capitalize.ljust(value + GUTTER) + "\n"
      else
        print field.to_s.capitalize.ljust(value + GUTTER)
      end
    end
    border_line
  end

end