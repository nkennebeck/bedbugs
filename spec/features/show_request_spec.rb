require 'rails_helper'

RSpec.describe "show page", type: :feature do
  before :each do
    RentalProperty.create!(:title => "lovely", :description => "all you need to know", :price => 0.50, :maxpersons => 6, :lat => 51.692139, :lng => -3.317871)
    RentalProperty.create!(:title => "stinky", :description => "yup, it smells", :price => 2.30, :maxpersons => 4, :lat => 35.807790, :lng => -5.559082)

    visit "/rental_properties"
  end

  it "should have links from each rental property title to 'show' pages" do
    expect(page).to have_link("lovely")
    expect(page).to have_link("stinky")
  end

  it "clicking on link for property should show details for that property" do
    click_link("lovely")
    expect(page).to have_link("Back to rental properties list")
    expect(page).to have_content("lovely")
    expect(page).to have_content("all you need to know")
    expect(page).to have_content("0.50")
  end

  it "clicking on link for property should show details for that property" do
    click_link("stinky")
    expect(page).to have_link("Back to rental properties list")
    expect(page).to have_content("stinky")
    expect(page).to have_content("yup, it smells")
    expect(page).to have_content("2.30")
  end

  it "should have a link to go back to the index" do
    click_link("stinky")
    expect(page).to have_link("Back to rental properties list")
  end

  it "should have a link to edit the property" do
    click_link("stinky")
    expect(page).to have_link("Edit rental property details")
  end

  it "should have a link to delete the property" do
    click_link("stinky")
    expect(page).to have_link("Delete rental property")
  end
end
