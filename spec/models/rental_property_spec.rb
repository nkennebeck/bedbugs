require 'rails_helper'

RSpec.describe RentalProperty, type: :model do
  describe "check attributes and methods" do
    it "should be able to create a RentalProperty object which has the correct methods on it" do
      rp = RentalProperty.create!(title: "Pwll o le", description: "", bedrooms: 2, beds: 2, maxpersons: 4, bathrooms: 1, pets_allowed: false, address: "Rockport, ME", price: 120.50, lat: 44.1845, lng: 69.0761)
      expect(rp).to respond_to :title
      expect(rp).to respond_to :description
      expect(rp).to respond_to :bedrooms
      expect(rp).to respond_to :beds
      expect(rp).to respond_to :bathrooms
      expect(rp).to respond_to :maxpersons
      expect(rp).to respond_to :pets_allowed
      expect(rp).to respond_to :address
      expect(rp).to respond_to :price
      expect(rp).to respond_to :lat
      expect(rp).to respond_to :lng
      expect(rp).to respond_to :distance_from
      expect(RentalProperty).to respond_to :filter_on_constraints
    end
  end

  it "should fail to create a RentalProperty object if the lat/lng are not specified" do
      expect {
          RentalProperty.create!(title: "Pwll o le", description: "", bedrooms: 2, beds: 2, maxpersons: 4, bathrooms: 1, pets_allowed: false, address: "Rockport, ME", price: 120.50)}.to raise_exception ActiveRecord::NotNullViolation
  end

  describe "distance_from tests" do
    before(:example) do
      rp = RentalProperty.create!(title: "Pwll o le", description: "", bedrooms: 2, beds: 2, maxpersons: 4, bathrooms: 1, pets_allowed: false, address: "Rockport, ME", price: 120.50, lat: 44.1845, lng: 69.0761)
    end

    it "should return nil if the location given is nil" do
      rp = RentalProperty.first
      expect(rp.distance_from(nil)).to be_nil
    end

    it "should return an accurate distance if the location is not nil" do
      rp = RentalProperty.first
      expect(rp.distance_from([44.184, 69.076])).to be_within(1).of(0)
    end
  end

  describe "filter_on_constraints tests" do
    before(:example) do
      1.upto(3) do |i|
        RentalProperty.create!(title: "Pwll o le #{i}", bedrooms: "#{i}", beds: "#{i*2}", maxpersons: "#{i*4}", bathrooms: "#{i}", pets_allowed: i%2==0, price: i*10.25, lat: 0, lng: 0)
      end
    end

    it "should filter correctly for pets_allowed" do
      q = RentalProperty.filter_on_constraints(:pets_allowed => true)
      expect(q.length).to eq(1)
    end

    it "should filter correctly for bedrooms" do
      q = RentalProperty.filter_on_constraints(:bedrooms => 2)
      expect(q.length).to eq(2)
      q = RentalProperty.filter_on_constraints(:bedrooms => 4)
      expect(q.length).to eq(0)
    end

    it "should filter correctly for bathrooms" do
      q = RentalProperty.filter_on_constraints(:bathrooms => 0)
      expect(q.length).to eq(3)
      q = RentalProperty.filter_on_constraints(:bathrooms => 1)
      expect(q.length).to eq(3)
      q = RentalProperty.filter_on_constraints(:bathrooms => 3)
      expect(q.length).to eq(1)
      q = RentalProperty.filter_on_constraints(:bathrooms => 4)
      expect(q.length).to eq(0)
    end

    it "should filter correctly on maxpersons" do
      q = RentalProperty.filter_on_constraints(:maxpersons => 11)
      expect(q.length).to eq(1)
      q = RentalProperty.filter_on_constraints(:maxpersons => 12)
      expect(q.length).to eq(1)
      q = RentalProperty.filter_on_constraints(:maxpersons => 13)
      expect(q.length).to eq(0)
      q = RentalProperty.filter_on_constraints(:maxpersons => 8)
      expect(q.length).to eq(2)
    end

    it "should filter correctly on multiple constraints" do
      q = RentalProperty.filter_on_constraints(:pets_allowed => false,
         :maxpersons => 7, :beds => 2)
      expect(q.length).to eq(1)
    end

    it "should ignore invalid constraints" do
      q = RentalProperty.filter_on_constraints(:dogs_allowed => false,
         :people => 7, :pool_tables => 20)
      expect(q.length).to eq(3)
    end
  end
end
