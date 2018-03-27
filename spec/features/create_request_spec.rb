require 'rails_helper'

RSpec.describe "show page", type: :feature do
  before :each do
    RentalProperty.create!(:title => "lovely", :description => "all you need to know", :price => 0.50, :maxpersons => 6, :lat => 51.692139, :lng => -3.317871)
    RentalProperty.create!(:title => "stinky", :description => "yup, it smells", :price => 2.30, :maxpersons => 4, :lat => 35.807790, :lng => -5.559082)

    visit "/rental_properties"
  end

  it "should be able to create a new rental property" do
    expect(page).to have_link("Create a new rental property listing")
    click_link("Create a new rental property listing")
    fill_in "Title", :with => "newone"
    fill_in "Description", :with => "newone"
    fill_in "Maximum occupancy", :with => 10
    fill_in "Number of bedrooms", :with => 3
    fill_in "Total number of beds", :with => 6
    fill_in "Total number of bathrooms", :with => 3
    fill_in "Address", :with => "Hamilton, NY"
    click_button "Create rental property listing"
    visit "/rental_properties"

    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(3)
    expect(names).to include("newone")

    p = RentalProperty.find(3)
    expect(p.lat.to_f).to be_within(1).of(42.8)
    expect(p.lng.to_f).to be_within(1).of(-75)
  end

  it "should be able to create a new rental property" do
    expect(page).to have_link("Create a new rental property listing")
    click_link("Create a new rental property listing")
    fill_in "Title", :with => "newone"
    fill_in "Description", :with => "newone"
    fill_in "Maximum occupancy", :with => 10
    fill_in "Number of bedrooms", :with => 3
    fill_in "Total number of beds", :with => 6
    fill_in "Total number of bathrooms", :with => 3
    fill_in "Address", :with => "Hamilton, NY"
    click_button "Create rental property listing"
    visit "/rental_properties"

    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(3)
    expect(names).to include("newone")

    p = RentalProperty.find(3)
    expect(p.lat).to be_within(1).of(42.8)
    expect(p.lng).to be_within(1).of(-75)
  end

  it "should fail to create a new rental property if no address is specified" do
    expect(page).to have_link("Create a new rental property listing")
    click_link("Create a new rental property listing")
    fill_in "Title", :with => "newone"
    fill_in "Description", :with => "newone"
    fill_in "Maximum occupancy", :with => 10
    fill_in "Number of bedrooms", :with => 3
    fill_in "Total number of beds", :with => 6
    fill_in "Total number of bathrooms", :with => 3
    fill_in "Address", :with => ""
    click_button "Create rental property listing"
    visit "/rental_properties"

    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(2)
  end
end
