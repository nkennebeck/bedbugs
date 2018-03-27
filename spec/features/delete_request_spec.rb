require 'rails_helper'

RSpec.describe "delete page", type: :feature do
  before :each do
    RentalProperty.create!(:title => "lovely", :description => "all you need to know", :price => 0.50, :maxpersons => 6, :lat => 51.692139, :lng => -3.317871)
    RentalProperty.create!(:title => "stinky", :description => "yup, it smells", :price => 2.30, :maxpersons => 4, :lat => 35.807790, :lng => -5.559082)

    visit "/rental_properties"
  end

  it "should correctly implement delete" do
    expect(page).to have_link("lovely")
    click_link("lovely")
    expect(page).to have_link("Delete rental property")
    click_link("Delete rental property")
    visit "/rental_properties"
    names = []
    page.all(".title").each { |x| names << x.text }
    expect(names.length).to eq(1)
    expect(names).to include("stinky")
  end
end
