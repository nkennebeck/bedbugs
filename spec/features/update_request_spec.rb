require 'rails_helper'

RSpec.describe "show page", type: :feature do
  before :each do
    RentalProperty.create!(:title => "lovely", :description => "all you need to know", :price => 0.50, :maxpersons => 6, :lat => 51.692139, :lng => -3.317871)
    RentalProperty.create!(:title => "stinky", :description => "yup, it smells", :price => 2.30, :maxpersons => 4, :lat => 35.807790, :lng => -5.559082)

    visit "/rental_properties"
  end

  it "should correctly allow a property to be updated" do
    expect(page).to have_link("lovely")
    click_link("lovely")
    expect(page).to have_link("Edit rental property details")
    click_link("Edit rental property details")
    fill_in "Title", :with => "new title"
    click_button("Update rental property details")
    visit "/rental_properties"

    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(2)
    expect(names).to include("new title")
    expect(names).to include("stinky")
  end

  it "should correctly allow a property to be updated" do
    expect(page).to have_link("lovely")
    click_link("lovely")
    expect(page).to have_link("Edit rental property details")
    click_link("Edit rental property details")
    fill_in "Address", :with => "Hamilton NY"
    click_button("Update rental property details")
    visit "/rental_properties"

    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(2)
    expect(names).to include("lovely")
    expect(names).to include("stinky")

    p = RentalProperty.find(1)
    expect(p.lat.to_f).to be_within(1).of(42.8)
    expect(p.lng.to_f).to be_within(1).of(-75)
  end

end
