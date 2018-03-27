class RentalProperty < ApplicationRecord
  has_attached_file :image, :styles=> {:medium => "300x300>", :thumb => "100x100>" }, :default_url => "noimg.png"

  validates_attachment :image, :content_type => {:content_type => ["image/jpeg", "image/png", "image/gif"]}

  acts_as_mappable


#make sure there's not a mismatch of data type in params (strings vs symbols)
  def self.filter_on_constraints(constraint_hash)
    records = RentalProperty.all
    operator_hash = {
        :bedrooms => '>=',
        :beds => '>=',
        :maxpersons => '>=',
        :bathrooms => '>=',
        :pets_allowed => '==',
        :price => '<=',
    }
    constraint_hash.each_pair do |symbol, value|
      operator = operator_hash[symbol.to_sym]
      #byebug
      if !value.to_s.empty?
        if !operator.nil?
          records = records.where("#{symbol.to_s} #{operator} ?", value)
        end
        if symbol.to_s == "within"
          geo=Geokit::Geocoders::MultiGeocoder.geocode(constraint_hash[:miles_of])
          records = RentalProperty.within(symbol, :origin => geo)
        end
      end
    end
    records
  end

  def distance_from(location)
      return nil if location.nil?
      return  distance_to(location)
  end
end
