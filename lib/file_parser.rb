# require './lib/phone'
# require './lib/zipcode'

class FileParser

  FIELDS = [ :last_name, :first_name,
             :mail_address, :zipcode,
             :city, :state, :street, :homephone]


  def get_data(filename)
    data = []
    contents = CSV.open "data/#{filename}", headers: true, header_converters: :symbol

    data = contents.collect do |person|
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
    puts data.inspect
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


      # person_hash["first_name"] = person[:first_name].to_s
      # person_hash["last_name"] = person[:last_name].to_s
      # person_hash["email_address"] = person[:email_address].to_s
      # person_hash["homephone"] = Phone.new(person[:homephone].to_s).clean_phone_number
      # person_hash["street"] = person[:street].to_s
      # person_hash["city"] = person[:city].to_s
      # person_hash["state"] = person[:state].to_s
      # person_hash["zipcode"] = Zipcode.new(person[:zipcode].to_s).clean_zipcode
      # data.push(person_hash)

      # last_name = person[:last_name].to_s
      # first_name = person[:first_name].to_s
      # email_address = person[:email_address].to_s
      # zipcode = Zipcode.new(person[:zipcode].to_s).clean_zipcode
      # city = person[:city].to_s
      # state = person[:state].to_s
      # street = person[:street].to_s
      # homephone = Phone.new(person[:homephone].to_s).clean_phone_number
      # attendee = Attendee.new(last_name, first_name, email_address, zipcode, city, state, street, homephone)