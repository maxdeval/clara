class AddressService

  def upload(address, asker)
    asker.v_location_label         = address.label
    asker.v_location_route         = address.route
    asker.v_location_city          = address.city
    asker.v_location_country       = address.country
    asker.v_location_zipcode       = address.zipcode
    asker.v_location_citycode      = address.citycode
    asker.v_location_street_number = address.street_number
    asker.v_location_state         = address.state
  end

  def download(address, asker)
    address.label         = asker.v_location_label
    address.route         = asker.v_location_route
    address.city          = asker.v_location_city
    address.country       = asker.v_location_country
    address.zipcode       = asker.v_location_zipcode
    address.citycode      = asker.v_location_citycode
    address.street_number = asker.v_location_street_number
    address.state         = asker.v_location_state
  end

  def reset(asker)
    asker.v_location_label         = nil
    asker.v_location_route         = nil
    asker.v_location_city          = nil
    asker.v_location_country       = nil
    asker.v_location_zipcode       = nil
    asker.v_location_citycode      = nil
    asker.v_location_street_number = nil
    asker.v_location_state         = nil
  end

end
