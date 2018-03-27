# This file contains all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

RentalProperty.delete_all

RentalProperty.create!(title: "Getaway Cottage", description: "Cozy, quaint cottage. Perfect for a weekend getaway.  Sleeps four.  No pets allowed.", bedrooms: 2, beds: 2, maxpersons: 4, bathrooms: 1, pets_allowed: false, address: "Rockport, ME", price: 120.50, lat: 44.1845, lng: -69.0761)
RentalProperty.create!(title: "Lovely Cabin", description: "Adirondack cabin in the middle of the woods. Watch out for bears!", bedrooms: 1, beds: 2, maxpersons: 3, bathrooms: 1, pets_allowed: false, address: "Keene, NY", price: 203.87, lat: 44.2562, lng: -73.7921)
RentalProperty.create!(title: "Loft apartment", description: "Apartment in a converted warehouse above two restaurants and a bar.  Amazingly quiet for all that activity downstairs.", bedrooms: 1, beds: 1, maxpersons: 2, bathrooms: 1, pets_allowed: true, address: "Albany, NY", price: 99.99, lat: 42.6526, lng: -75.7562)
RentalProperty.create!(title: "Single family home", description: "Two story house with 3 bedrooms, a big backyard, and located in quiet neighborhood.  Walking distance to everything and nothing, all at once.", bedrooms: 3, beds: 3, maxpersons: 4, bathrooms: 2, pets_allowed: false, address: "Hamilton, NY", price: 175.13, lat: 42.8270, lng: -75.5446)
RentalProperty.create!(title: "Sofa at former coffee shop", description: "Comfy sofa available for rent in a studio setting: a recently forclosed coffee shop.  As long as you can pick the lock, you're in! It's quiet and comfy, and smells like coffee all the time, although unfortunately there is no actual coffee available.  Some crumbs left over from former tenants.", bedrooms: 0, beds: 1, maxpersons: 1, bathrooms: 0, pets_allowed: true, address: "Hamilton, NY", price: 13.99, lat: 42.8270, lng: -75.5446)
