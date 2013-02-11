class FileParser

  attr_accessor :data

  FIELDS = [ :last_name, :first_name,
             :email_address, :zipcode,
             :city, :state, :street, :homephone]

  def initialize
    @data = []
  end

  def get_data(filename)
    #data = []
    contents = CSV.open "data/#{filename}", headers: true,
                                            header_converters: :symbol

    @data = contents.collect do |person|
      person_hash = {}

      FIELDS.each do |field|
        if field == :zipcode || field == :homephone
          person_hash[field] = clean_data(field, person[field].to_s)
        else
          person_hash[field] = person[field].to_s
        end
      end
      person_hash
    end
  end

  def clean_data(field, value)
    case field
    when :zipcode
      Zipcode.new.clean(value)
    when :homephone
      Phone.new.clean(value)
    else
      "unknown input"
    end
  end

end