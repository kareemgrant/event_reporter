class Prompt

  # Add to yaml
  # COMMANDS = {"load <filename>" => "Erase any loaded data and parse the specified file. If no filename is given, default to event_attendees.csv",
  #                "help" => "Output a dataing of the available individual commands",
  #                "help <command>" => "Output a description of how to use the specific command",
  #                "queue count" => "Output how many records are in the current queue",
  #                "queue clear" => "Empty the queue",
  #                "queue print" => "Print out a tab-delimited data table with a header row",
  #                "queue print by <attribute>" => "Print the data table sorted by the specified attribute like zipcode",
  #                "queue save to <filename.csv>" => "Export the current queue to the specified filename as a CSV",
  #                "find <attribute> <criteria>" => "Load the queue with all records matching the criteria for the given attribute",
  #                "quit" => "Quit the EventReporter program"}

  # Format and align
  FIELDS = {
            "First_name" => 10,
            "Last_name" => 9,
            "Email_address" => 13,
            "Homephone" => 9,
            "Street" => 6,
            "City" => 4,
            "State" => 5,
            "Zipcode" => 10}

  GUTTER = 2

  def initialize(greeting)
    @greeting = greeting
    @data = []
    @queue = []
  end

  # method name is too generic 
  # def run
  #   puts @greeting

  #   command = ""
  #   while command != "quit"
  #     printf "Enter command:"

  #     input = gets.chomp.downcase
  #     #command, options = input.split(" ")....

  #     parts = input.split(" ")

  #     command = parts[0]
  #     options = parts[1..-1]

  #     process_command(command, options)
  #   end
  # end

  private 

  # use case statement instead of elsif
  # respond_to?(method)
  # send("process_#{command}", options)
  # o.foo(args)
  # o.send(:foo, args)
  # o.send("foo", args)

  # def process_command(command, options)
  ## method = "process_#{command}"
  ## if respond_to?(method)
  #     send(method, options)
  #    else
  #    error_message("no command")
  #    end
  # end

  # or

  # def process_command(command, options)
  #   method = "process_#{command}"
  #   begin
  #     send(method, options)
  #   rescue NoMethodError
  #     error_message("no command")
  #   end
  # end

  def process_command(command, options)
    if command == 'load'
      process_load(options)
    elsif command == 'help'
      args = options[0..-1]
      process_help(options)
    elsif command == 'find'
      process_find(options)
    elsif command == 'queue'
      args = options[0..-1]
      process_queue(args)
    elsif command == "quit"
      puts "Quiting the program"
    else
      error_message("no command")
    end
  end

  # def process_load(options)
  #   filename = options.join
  #   if options[0].to_s == ""
  #     filename = "event_attendees.csv"
  #   end

  #   if File.exists?("data/#{filename}")
  #     load_file(filename)
  #   else
  #     error_message("no file")
  #   end

    # fix the options
    # check if the file exists
    # if, load it
  end

  def process_load(options)
    if options[0].to_s == ""
      load_file("event_attendees.csv")
    else
      filename = options[0..-1].join
      if File.exists?("data/#{filename}")
        load_file(filename)
      else
        error_message("no file")
      end
    end
  end

  def process_help(args)
    if args.empty?
      help
    else
      args.join(" ")
      help(args)
    end
  end

  def process_find(options)
    args = options[0..-1]
    if args.empty?
      error_message("no args")
    elsif (attribute_exist?(options[0]) == false) && options[1].to_s != ""
      error_message("no attribute")
    elsif options[1].to_s == ""
      error_message("no criteria")
    else
      args = options[0..-1].join(" ")
      find(args)
    end
  end

  def process_queue(args)
    if args.empty?
      error_message("no args")
    elsif args[0] == "count"
      queue_count
    elsif args[0] == "clear"
      queue_clear
    elsif args[0] == "print" && args[1] != "by"
      @queue.empty? ? error_message("queue empty") : queue_print
    elsif args[0] == "print" && args[1] == "by"
      @queue.empty? ? error_message("queue empty") : sort_queue(args[2])
    elsif args[0] == "save" && args[1] == "to"
      args[2].downcase == "event_attendees.csv" ? error_message("no overwrite") : queue_save(args[2])
    else
      error_message("")
    end
  end

  def load_file(filename)
    @data = EventAttendee.new(filename).get_attendees
    puts "Confirmation: #{filename} was successfully loaded"
    puts "There were #{@data.length} records retrieved"
  end

  def find(*args)
    @queue = []
    options = args.join(" ").split
    if options.include?("and")
      multi = true
      and_cursor = options.index("and")
      first_args = options[0..(and_cursor-1)]
      second_args = options[(and_cursor+1)..-1]

      attribute1 = first_args[0]
      attribute2 = second_args[0]
      criteria1 = first_args[1..-1].join(" ")
      criteria2 = second_args[1..-1].join(" ")
      search(multi,attribute1, criteria1, attribute2, criteria2)
    else
      multi = false
      attribute1 = options[0]
      criteria1 = options[1..-1].join(" ")
      search(multi, options[0], options[1..-1].join(" "))
    end
  end

  def search(multi, *args)
    if multi
      @queue = @data.select {|person| person[args[0].to_sym].downcase == args[1].downcase }
      @queue = @queue.select {|person| person[args[2].to_sym].downcase == args[3].downcase }
      puts "#{@queue.size} records found"
    else
      @queue = @data.select {|person| person[args[0]].downcase == args[1].downcase }
      puts "#{@queue.size} records found"
    end
  end

  # def multi_search()
  # end

  # def normal_search()
  # end



  def queue_count
    puts "There are #{@queue.size} records currently in the queue"
  end

  def queue_clear
    @queue = [] 
    puts "queue has been cleared"
  end

  def queue_save(filename)
    header_row = ["Last_name", "First_name", "Email_address", "Zipcode", "City", "State", "Street", "Homephone"]
    puts "in write_to_csv to method"
    Dir.mkdir("data") unless Dir.exists?("data") 
    CSV.open("data/#{filename}", "w") do |csv|
      csv << header_row
      @queue.each do |person|
        csv << [person[:last_name], person[:first_name], person[:email_address], person[:zipcode], person[:city], person[:state], person[:street], person[:homephone]]
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



  def print_results_header(field_widths)
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
      if col_width > header_width
        fields_widths_hash[name.downcase] = col_width
      else
        fields_widths_hash[name.downcase] = header_width
      end
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



  def attribute_exist?(attribute)
    FIELDS.has_key?(attribute.capitalize)
  end

  def error_message(e)
    case e
    when "queue empty" then puts "Command cannot be completed because the queue is empty"
    when "no data" then puts "No Event Attendee information was found, please make sure you loaded a file using the LOAD command"
    when "no args" then puts "The command you are using is requires additional options, type HELP for more details"
    when "no file" then puts "The file you are attempting to Load does not exist"
    when "no overwrite" then puts "You are not authorized to overwrite this file"
    when "no command" then puts "The command you entered does not exist, please type HELP for more details"
    when "no attribute" then puts "The field that you are attempting to query does not exist the current fields, please search for a valid field"
    when "no criteria" then puts "Your FIND command is missing the require criteria option, type HELP for more details"
    else
      puts "The Command entered could not be found, please check your input again"
    end
  end

end