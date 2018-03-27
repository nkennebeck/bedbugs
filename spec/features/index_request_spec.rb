require 'rails_helper'

RSpec.describe "index page", type: :feature do
  let(:title_sort) {["abhorrent", "gorgeous", "lovely", "stinky"]}
  let(:price_sort) {["lovely", "abhorrent", "stinky", "gorgeous"]}
  let(:details_sort) {["stinky", "lovely", "gorgeous", "abhorrent"]}
  let(:distance_sort) {["abhorrent", "gorgeous", "stinky", "lovely"]}

  before :each do
    RentalProperty.create!(:title => "abhorrent", :price => 1.50, :maxpersons => 10, :lat => 7.698744, :lng => -0.593262, :bathrooms => 3)
    RentalProperty.create!(:title => "gorgeous", :price => 3.50, :maxpersons => 8, :lat => 6.434036, :lng => 16.501465, :bathrooms => 3)
    RentalProperty.create!(:title => "lovely", :price => 0.50, :maxpersons => 6, :lat => 42.8270, :lng => -75.5446, :bathrooms => 4)
    RentalProperty.create!(:title => "stinky", :price => 2.30, :maxpersons => 4, :lat => 35.807790, :lng => -5.559082, :bathrooms => 4)

    allow_any_instance_of(RentalPropertiesController).to receive(:session).and_return({:geo_location => {"success" => true, "lat" => 42.8270, "lng" => -75.5446}} )
    visit "/rental_properties"
  end

  it "should show the rental properties in title order by default" do
    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names).to match_array(names.sort)
  end

  it "should show the rental properties in correct price order when sorting by price" do
    names = []
    click_link("Price per night")
    page.all(".title").each { |x| names << x.text }
    expect(names).to match_array(price_sort)
  end

  it "should show the rental properties maxpersons order when sorting by details" do
    names = []
    click_link("Details")
    page.all(".title").each { |x| names << x.text }
    expect(names).to match_array(details_sort)
  end

  it "should show the rental properties in correct order when sorting by distance" do
    names = []
    click_link("Distance from you")
    page.all(".title").each { |x| names << x.text }
    expect(names).to match_array(distance_sort)
  end

  it "should do the correct filtering when filtering by maxpersons" do
    fill_in "Maximum occupants", :with => "10"
    click_button "Refine the list of rental properties"
    visit "/rental_properties"
    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(1)
    visit "/rental_properties"
    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(1)
    fill_in "Maximum occupants", :with => " "
    click_button "Refine the list of rental properties"
    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(4)
  end

  it "should do the correct filtering when filtering by bathrooms" do
    fill_in "Number of bathrooms", :with => "4"
    click_button "Refine the list of rental properties"
    visit "/rental_properties"
    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(2)
    visit "/rental_properties"
    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(2)
    fill_in "Number of bathrooms", :with => " "
    click_button "Refine the list of rental properties"
    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(4)
  end

  it "should do the correct filtering when filtering by price" do
    fill_in "Maximum price", :with => "1"
    click_button "Refine the list of rental properties"
    visit "/rental_properties"
    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(1)
    visit "/rental_properties"
    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(1)
    fill_in "Maximum price", :with => " "
    click_button "Refine the list of rental properties"
    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(4)
  end

  it "should do the correct filtering when filtering by distance" do
    fill_in "Within", :with => "100"
    fill_in "miles of", :with => "Hamilton, NY"
    click_button "Refine the list of rental properties"
    visit "/rental_properties"
    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(1)
    visit "/rental_properties"
    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(1)
    visit "/rental_properties"
    fill_in "Within", :with => ""
    fill_in "miles of", :with => ""
    click_button "Refine the list of rental properties"
    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(4)
  end

  it "should have a link to create a new property" do
    expect(page).to have_link("Create a new rental property listing")
  end
end
