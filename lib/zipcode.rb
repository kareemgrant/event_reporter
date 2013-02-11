class Zipcode
  attr_accessor :zipcode

  def clean(zipcode)
    zipcode.to_s.rjust(5, '0')[0,5]
  end
end