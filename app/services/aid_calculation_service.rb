class AidCalculationService

  class << self
    protected :new
  end
  
  @@the_double = nil

  # Allow DI for testing purpose
  def AidCalculationService.set_instance(the_double)
    @@the_double = the_double
  end

  def AidCalculationService.get_instance(asker)
    @@the_double.nil? ? AidCalculationService.new(asker) : @@the_double
  end

  def initialize(asker)
    aids_as_hash = ActivatedModelsService.get_instance.aids

    @calculated_aids_as_hash =  aids_as_hash.map do |aid_as_hash|
      eligibility = RuletreeService.get_instance.resolve(aid_as_hash["rule_id"], asker.attributes)
      aid_as_hash["eligibility"] = eligibility
      aid_as_hash
    end
  end

  # deprecated
  def all_eligible
    result_service = ResultService.new
    @calculated_aids_as_hash
      .select { |calculated_aid_as_hash| calculated_aid_as_hash["eligibility"] == "eligible" }
      .map { |calculated_aid_as_hash| result_service.convert_to_displayable(calculated_aid_as_hash) }
  end

  # deprecated
  def all_ineligible
    result_service = ResultService.new
    @calculated_aids_as_hash
      .select { |calculated_aid_as_hash| calculated_aid_as_hash["eligibility"] == "ineligible" }
      .map { |calculated_aid_as_hash| result_service.convert_to_displayable(calculated_aid_as_hash) }
  end

  # deprecated
  def all_uncertain
    result_service = ResultService.new
    @calculated_aids_as_hash
      .select { |calculated_aid_as_hash| calculated_aid_as_hash["eligibility"] == "uncertain" }
      .map { |calculated_aid_as_hash| result_service.convert_to_displayable(calculated_aid_as_hash) }
  end

  def every_eligible
    _every_aids_that_are("eligible")
  end

  def every_uncertain
    _every_aids_that_are("uncertain")
  end

  def every_ineligible
    _every_aids_that_are("ineligible")
  end

  def _every_aids_that_are(status)
    _all_aids.select { |a| a["eligibility"] == status }.map { |e| e.select { |key, _| _wanted_keys.include? key }  }
  end

  def _wanted_keys
    %w[id name slug slug short_description ordre_affichage contract_type_id eligibility filters]
  end

  def _all_aids
    @calculated_aids_as_hash
  end


end
