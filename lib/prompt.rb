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

  GUTTER = 5

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
    # puts @data
    puts "Confirmation: #{filename} was successfully loaded"
    # reminder: check if file exists in the current directory
  end

  def help(*option)
    #puts option.inspect
    if option.empty?
      print_commands(COMMANDS)
    else
      #puts option[0..-1]
      command = option[0..-1].join(" ")
      #puts "the command passed into help: #{command}"
      if COMMANDS.include?(command)
        new_hash = Hash.new
        new_hash[command] = COMMANDS[command]
        print_commands(new_hash)
      else
        puts "In help method: Sorry that command is not supported"
      end
    end
  end

  def find(args)
    #puts "the the number of attendees in csv file: #{@data.length} "
    @queue = []
    array = args.split
    # puts "attribute: #{array[0]}"
    # puts "criteria: #{array[1]}"
    search(array[0], array[1..-1].join(" "))
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
      # call the find method by searching the data of attendees and returning an array
      if args.empty?
        puts "Cannot call find without an attribute and criteria"
      else
        # puts "calling find method with args"
        args = options[0..-1].join(" ")
        find(args)
      end

    elsif command == 'queue'
      args = options[0..-1]
      if args.empty?
        puts "You cannont call queue without specifying additional options"
      elsif args[0] == "count"
        # call queue_count
        queue_count
      elsif args[0] == "clear"
        # call queue_clear
        queue_clear
      elsif args[0] == "print" && args[1] != "by"
        # call queue_print
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

  def search(attribute, criteria)
    #puts "In search method data is equal to #{@data}" 
    @queue = @data.select {|person| person[attribute.to_sym].downcase == criteria.downcase }
    puts "#{@queue.size} records found"
  end

  def print_queue
    #puts "Longest last name is #{get_longest_value}"
    #get_longest_value("last_name")
    field_widths = get_column_widths(FIELDS)
    print_results_header(field_widths)
    #puts field_widths.inspect
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
    #puts "print_results_header"
    puts field_widths.inspect
    puts ""
    border_line
    print "LAST NAME".ljust(field_widths["last_name"] + GUTTER) + "FIRST NAME".ljust(field_widths["first_name"] + GUTTER) + "EMAIL".ljust(field_widths["email_address"] + GUTTER) + 
          "ZIPCODE".ljust(field_widths["zipcode"] + GUTTER) + "CITY".ljust(field_widths["city"] + GUTTER) + "STATE".ljust(field_widths["state"] + GUTTER) + "ADDRESS".ljust(field_widths["street"] + GUTTER) + 
          "PHONE".ljust(field_widths["homephone"]) + "\n"
    border_line
  end

  def sort_queue(attribute)
    puts "in sort_queue method"
    @queue = @queue.sort_by do |person|
      person[attribute.to_sym].downcase
    end
    queue_print
  end


  def queue_count
    puts "There are #{@queue.size} records currently in the queue"
  end

   def queue_clear
    puts "clearing the queue"
    @queue = [] 
    puts "queue has been cleared"
  end

  def queue_print
    #print_results_header
    print_queue
  end

  # def queue_save(filename)
  #   # save data to external file
  #   row_array = []
  #  @queue.each do |person| 
  #     row_array.push(generate_row(person))
  #   end
  #   puts "in queue_save"
  #   puts row_array.inspect
  #   write_to_csv(row_array, filename)
  # end

  def queue_save(filename)
    header_row = ["First_name", "Last_name", "Email_address", "Homephone", "Street", "City", "State", "Zipcode"]
    puts "in write_to_csv to method"
    Dir.mkdir("data") unless Dir.exists?("data") #create output dir unless it already exists
    CSV.open("data/#{filename}", "w") do |csv|
      csv << header_row
      @queue.each do |person|
        csv << [person[:first_name], person[:last_name], person[:email_address], person[:zipcode], person[:city], person[:state], person[:street], person[:homephone]]
      end
    end
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

  def print_commands(commands_hash) # store this in a hash
    header
    commands_hash.each do |command, desc| 
      print command.ljust(40) + desc.ljust(15) + "\n"
    end
    border_line
  end

  def calc_column_widths 

  end

  def get_column_widths(fields)
    fields_widths_hash = {}
    fields.each do |name, width|
      # puts name
      # puts width
      header_width = get_header_width(name.downcase)
      # puts "header width: #{header_width}"
      col_width = get_longest_value(name.downcase)
      # puts "col width: #{col_width}"
      fields_widths_hash[name.downcase] = col_width > header_width ? col_width : header_width
    end
    fields_widths_hash
  end

  def get_header_width(field)
    # puts "In get_header_width method"
    # puts "#{field} was passed in"
    FIELDS[field.capitalize]
  end

  def get_longest_value(field) 
    array = []
    @queue.each do |person|
      array << person[field].length 
    end
    array.max
    # puts @queue[0][:last_name]
    # puts @queue[0][:last_name].length
  end


end