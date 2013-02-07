require_relative 'event_attendee'
# require 'csv'

class Prompt
  COMMANDS = {"load <filename>" => "Erase any loaded data and parse the specified file. If no filename is given, default to event_attendees.csv", 
                 "help" => "Output a dataing of the available individual commands",
                 "help <command>" => "Output a description of how to use the specific command",
                 "queue count" => "Output how many records are in the current queue",
                 "queue clear" => "Empty the queue",
                 "queue print" => "Print out a tab-delimited data table with a header row",
                 "queue print by <attribute>" => "Print the data table sorted by the specified attribute like zipcode",
                 "queue save to <filename.csv>" => "Export the current queue to the specified filename as a CSV",
                 "queue <attribute> <criteria>" => "Load the queue with all records matching the criteria for the given attribute",
                 "quit" => "Quit the EventReporter program"}

  FIELDS = {"First_name" => 10 , "Last_name" => 9, "Email_address" => 13, "Homephone" => 9, "Street" => 6, "City" => 4, "State" => 5, "Zipcode" => 10}

  GUTTER = 2

  def initialize(greeting)
    @greeting = greeting
    @data = []
    @queue = []
  end

  def run
    puts @greeting
    command = ""
    while command != "quit"
      printf "Enter command:"

      input = gets.chomp
      input = input.downcase

      parts = input.split(" ")

      command = parts[0]
      options = parts[1..-1]

      process_command(command, options)
    end
  end

  private 

  def load_file(filename)
    @data = EventAttendee.new(filename).get_attendees
    puts "There were #{@data.length} records retrieved"
    puts "Confirmation: #{filename} was successfully loaded"
  end

  def help(*option)
    if option.empty?
      print_commands(COMMANDS)
    else
      command = option[0..-1].join(" ")
      if COMMANDS.include?(command)
        new_hash = Hash.new
        new_hash[command] = COMMANDS[command]
        print_commands(new_hash)
      else
        puts "In help method: Sorry that command is not supported"
      end
    end
  end

  def find(*args)
    @queue = []
    options = args.join(" ").split
    # logic that evaluates the array and searches for the "and" string
    if options.include?("and")
      multi = true
      and_cursor = options.index("and")
      first_args = options[0..(and_cursor-1)]
      second_args = options[(and_cursor+1)..-1]

      attribute1 = first_args[0]
      attribute2 = second_args[0]
      criteria1 = first_args[1..-1].join(" ")
      criteria2 = second_args[1..-1].join(" ")
      # now send data to the search method
      search(multi,attribute1, criteria1, attribute2, criteria2)
    else
      # run multiple regular search
      multi = false
      attribute1 = options[0]
      criteria1 = options[1..-1].join(" ")
      search(multi, options[0], options[1..-1].join(" "))
    end
  end

  def process_command(command, options)

    if command == 'load'
      if options[0].to_s == ""
        load_file("full_event_attendees.csv")
        puts "no option was specified so the event_attendees.csv file was loaded by default"
      else
        load_file(options[0..-1].join)
        puts "loaded the following file: #{options[0]}"
      end

    elsif command == 'help'
      args = options[0..-1]
      if args.empty?
        puts "call help method without arg"
        help
      else
        puts "call help method with arg"
        args.join(" ")
        help(args)
      end

    elsif command == 'find'
      args = options[0..-1]
      if args.empty?
        puts "Cannot call find without an attribute and criteria"
      else
        args = options[0..-1].join(" ") #pass args as a string
        find(args)
      end

    elsif command == 'queue'
      args = options[0..-1]
      if args.empty?
        puts "You cannont call queue without specifying additional options"
      elsif args[0] == "count"
        queue_count
      elsif args[0] == "clear"
        queue_clear
      elsif args[0] == "print" && args[1] != "by"
        queue_print
      elsif args[0] == "print" && args[1] == "by"
        sort_queue(args[2])
      elsif args[0] == "save" && args[1] == "to"
        queue_save(args[2])
      end
    elsif command == "quit"
      puts "Quiting the program"
    else
      puts "Sorry that command is not supported"
    end
  end

  def search(multi, *args)
    puts "in search method"
    puts args.inspect
    if multi
      # true 
      attribute1 = args[0]
      criteria1 = args[1]
      attribute2 = args[2]
      criteria2 = args[3]

      puts "conducting first search"
      @queue = @data.select {|person| person[attribute1.to_sym].downcase == criteria1.downcase }

      puts "conducting second search on the existing queue results set"
      @queue = @queue.select {|person| person[attribute2.to_sym].downcase == criteria2.downcase }
      puts "#{@queue.size} records found"

    else
      attribute = args[0]
      criteria = args[1]
      #if @queue.empty?
        @queue = @data.select {|person| person[attribute.to_sym].downcase == criteria.downcase }
        puts "#{@queue.size} records found"
     # else
    #    puts("Your queue empty, there are no results to print")
    #  end
    end
  end

  def queue_count
    puts "There are #{@queue.size} records currently in the queue"
  end

  def queue_clear
    @queue = [] 
    puts "queue has been cleared"
  end

  def queue_save(filename)
    header_row = ["First_name", "Last_name", "Email_address", "Zipcode", "Street", "City", "State",  "Homephone"]
    puts "in write_to_csv to method"
    Dir.mkdir("data") unless Dir.exists?("data") #create output dir unless it already exists
    CSV.open("data/#{filename}", "w") do |csv|
      csv << header_row
      @queue.each do |person|
        csv << [person[:first_name], person[:last_name], person[:email_address], person[:zipcode], person[:city], person[:state], person[:street], person[:homephone]]
      end
    end
  end

  def sort_queue(attribute)
    puts "in sort_queue method"
    @queue = @queue.sort_by do |person|
      person[attribute.to_sym].downcase
    end
    queue_print
  end

  def queue_print
    @queue.empty? ? puts("Your queue empty, there are no results to print") : print_queue
  end

  def print_queue
    field_widths = get_column_widths(FIELDS)
    print_results_header(field_widths)
    count = 0
    q_size = @queue.size
    @queue.each do |person|
      if (count != 0) && (count % 10 == 0)
        puts "Displaying records #{count - 10} - #{count} of #{q_size}"
        input = ""
        while input != "\n" #|| input != "\n"
          puts "press space bar or the enter key to show the next set of records"
          input = gets
        end
      end
      print person[:last_name].ljust(field_widths["last_name"] + GUTTER) + person[:first_name].ljust(field_widths["first_name"] + GUTTER) + person[:email_address].ljust(field_widths["email_address"] + GUTTER) + 
            person[:zipcode].ljust(field_widths["zipcode"] + GUTTER) + person[:city].ljust(field_widths["city"] + GUTTER) + person[:state].ljust(field_widths["state"] + GUTTER) + 
            person[:street].ljust(field_widths["street"] + GUTTER) + person[:homephone].ljust(field_widths["homephone"]) + "\n" 
      count += 1
    end
  end

  def print_commands(commands_hash) # store this in a hash
    header
    commands_hash.each do |command, desc| 
      print command.ljust(40) + desc.ljust(15) + "\n"
    end
    border_line
  end

  def print_results_header(field_widths)
    #puts field_widths.inspect
    puts ""
    border_line
    print "LAST NAME".ljust(field_widths["last_name"] + GUTTER) + "FIRST NAME".ljust(field_widths["first_name"] + GUTTER) + "EMAIL".ljust(field_widths["email_address"] + GUTTER) + 
          "ZIPCODE".ljust(field_widths["zipcode"] + GUTTER) + "CITY".ljust(field_widths["city"] + GUTTER) + "STATE".ljust(field_widths["state"] + GUTTER) + "ADDRESS".ljust(field_widths["street"] + GUTTER) + 
          "PHONE".ljust(field_widths["homephone"]) + "\n"
    border_line
  end

  def get_column_widths(fields)
    fields_widths_hash = {}
    fields.each do |name, width|
      header_width = get_header_width(name.downcase)
      col_width = get_widest_field_value(name.downcase)
      fields_widths_hash[name.downcase] = col_width > header_width ? col_width : header_width
    end
    fields_widths_hash
  end

  def get_widest_field_value(field) 
    array = []
    @queue.each do |person|
      array << person[field].length 
    end
    array.max
  end

  def get_header_width(field)
    FIELDS[field.capitalize]
  end

  def border_line
    puts "-"*180
  end

  def header
    puts ""
    border_line
    print "Command".ljust(40) 
    print "Description".ljust(20) + "\n"
    border_line
  end

end