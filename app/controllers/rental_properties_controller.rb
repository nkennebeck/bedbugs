class RentalPropertiesController < ApplicationController
  geocode_ip_address

  # Dictates what is seen on the main page
  def index
    # sources the location of the user using Geokit
    @location = get_location

    @properties = RentalProperty.all
    order = params[:order] || :distance

    # sorts Rental Properties by a given order
    if order.to_sym != :distance
      @properties = @properties.order(order)
    else
      if !@location.nil?
        @properties = @properties.by_distance(:origin => @location)
      end
    end

    if !params[:maxpersons].nil?
      @properties = @properties.filter_on_constraints(params)
    end

    if !params[:within].nil? && !params[:miles_of].nil?
      if !@location.nil? && params[:within].empty? && params[:miles_of].empty?
        @properties = RentalProperty.within(params[:within], :origin => params[:miles_of])
      end
    end
  end

  # what is seen for each individual property page
  def show
    id = params[:id]
    @location = get_location
    @property = RentalProperty.find(id)
  end


  def new
    # don't need anything in here
  end


  def create
    if params[:rental_property][:address] == ""
      flash[:warning] = "Rental Property couldn't be created"
      redirect_to new_rental_property_path and return
    end

    geo=Geokit::Geocoders::MultiGeocoder.geocode(params[:rental_property][:address])

    if geo.success
      prop = RentalProperty.new(create_update_params)
      prop.lat = geo.lat
      prop.lng = geo.lng
      if prop.save
        flash[:notice] = "Rental Property #{prop.title} successfully created."
        redirect_to rental_properties_path
      else
        flash[:warning] = "Rental Property couldn't be created"
        redirect_to new_rental_property_path
      end
    else
      flash[:warning] = "Geocoding address failed"
      redirect_to new_rental_property_path
    end
  end


  def edit
    @property = RentalProperty.find params[:id]
  end


  def update
    @property = RentalProperty.find params[:id]
    if params[:rental_property][:address] != (@property.address)
      geo=Geokit::Geocoders::MultiGeocoder.geocode(@property.address)
      if geo.success
        @property.update(create_update_params)
        flash[:notice] = "#{@property.title} was successfully updated"
        redirect_to rental_property_path(@property)
      else
        flash[:warning] = "Geocoding address failed"
        redirect_to edit_rental_property_path(@property)
      end
    else
      @property.update(create_update_params)
      flash[:notice] = "#{@property.title} was successfully updated"
      redirect_to rental_property_path(@property)
    end
  end


  def destroy
    @property = RentalProperty.find(params[:id])
    @property.destroy
    flash[:notice] = "Rental Property '#{@property.title}' deleted."
    redirect_to rental_properties_path
  end


  private
  def get_location
    # if Geokit isn't working, comment out all other code
    # and hard code in a latitude and longitude
    # return [latitude,longitude]
    loc = session[:geo_location]
    if loc.nil?
      return loc
    else
      begin
        return [loc["lat"],loc["lng"]]
      rescue
        return nil
      end
    end
  end


  private
  def create_update_params
    params.require(:rental_property).permit(:title, :description, :bedrooms, :beds, :maxpersons, :bathrooms, :pets_allowed, :address, :price, :image)
  end

end
