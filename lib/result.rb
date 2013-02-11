class Result
  attr_accessor :queue

  FIELDS = [ :last_name, :first_name,
             :email_address, :zipcode,
             :city, :state, :street, :homephone]

  def initialize
    @queue = []
  end

  def find(data, *options)
    options = options.join(" ").split

    if (attribute_exist?(options[0]) == false)
      puts "Attribute does not exist"
    else
      @queue = []

      attribute = options[0]
      criteria = options[1]

      @queue = data.select do |person|
        person[attribute.to_sym].downcase == criteria.downcase
      end
    end
  end

  def count(*options)
    puts "#{@queue.size} records currently in the queue"
  end

  def clear(*options)
    @queue = []
    puts "The queue has been cleared"
  end

  def print(*options)
    options = options.join(" ").split
    #puts options.inspect

    if @queue.empty?
      puts "The queue is currently empty, there is nothing to print"
    elsif options[1].to_s == ""
      @printer ||= Printer.new
      @printer.print_queue(@queue)
    elsif options[1].to_s == 'by' && options[2].to_s != ""
      sort_queue(options[2])
    else
      puts "Invalid input please try again"
    end
  end

  def sort_queue(attribute)
    puts "attribute: #{attribute}"

    if attribute_exist?(attribute)
      @queue = @queue.sort_by do |person|
        person[attribute.to_sym].downcase
      end

      @printer ||= Printer.new
      @printer.print_queue(@queue)

    else
      puts "attribute does not exists, please enter in a valid field name"
    end
  end

  def save(*options)
    options = options.join(" ").split

    if options[1].to_s.downcase != "to"
      puts "invalid input, type HELP for more information"
    elsif options[2].to_s == ""
      puts "Missing filename"
    else
      filename = options[2]
      header_row = FIELDS.collect{|key, value| key.to_s.capitalize}
      puts header_row.inspect
      writer = FileWriter.new.write(@queue, filename, header_row)
    end
  end

  def attribute_exist?(attribute)
    FIELDS.include?(attribute.to_sym)
  end

end