class Vacant < ActiveRecord::Base

  has_many :projects, dependent: :destroy

  def self.search(params)
    search_params = get_search_params(params)

    if search_params.empty?
      vacants = Vacant.state_only
    else
			vacants = Vacant.by_full_address(search_params[:full_address])
									    .by_neighborhood(search_params[:neighborhood])
				              .by_police_district(search_params[:police_district])
                      .state_only
		end

		vacants
  end

  private

  # Expose incoming search parameters

  def self.get_search_params(params)
    sliced = params.compact.slice(:full_address, :neighborhood, :police_district)
		sliced.delete_if { |k, v| v.blank? }
  end

  # Validate incoming search paramters

	def self.by_full_address(full_address)
		return Vacant.all unless full_address.present?
		Vacant.where('full_address LIKE ?', "%#{full_address.upcase}%")
	end

  def self.by_neighborhood(neighborhood)
		return Vacant.all unless neighborhood.present?
		Vacant.where('neighborhood LIKE ?', "%#{neighborhood.upcase}%")
	end

  def self.by_police_district(police_district)
		return Vacant.all unless police_district.present?
		Vacant.where('police_district LIKE ?', "%#{police_district.upcase}%")
	end

  def self.state_only
    return Vacant.where('owner LIKE ?', "%MAYOR AND CITY%")
  end

end
