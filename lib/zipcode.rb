class Zipcode
  attr_accessor :zipcode
  
  def initialize(zip)
    @zipcode = zip
  end


  def clean_zipcode #(zipcode)
    @zipcode.to_s.rjust(5, '0')[0,5]

  # if zipcode.length == 5
  # 	zipcode
  # else
  # 	zipcode[0,5]
  # end
  # return zipcode
  end
end