class ActivatedModelsService

  class << self
    protected :new
  end

  @@the_double = nil

  # Allow DI for testing purpose
  def ActivatedModelsService.set_instance(the_double)
    @@the_double = the_double
  end

  def ActivatedModelsService.get_instance
    @@the_double.nil? ? ActivatedModelsService.new : @@the_double
  end

  def initialize
    activated_models = CacheService.get_instance.read("activated_models")
    begin
      JSON.parse(activated_models)
    rescue Exception => e
      all_activated_aids = Aid.activated.to_json(:include => :filters)
      all_filters = Filter.all.to_json
      all_contracts = ContractType.all.to_json
      all_rules = Rule.all.to_json
      activated_models = {}
      activated_models["all_activated_aids"] = _clean_all_activated_aids(JSON.parse(all_activated_aids))
      activated_models["all_filters"] = JSON.parse(all_filters)
      activated_models["all_contracts"] = JSON.parse(all_contracts)
      activated_models["all_rules"] = JSON.parse(all_rules)
      p '- - - - - - - - - - - - - - activated_models- - - - - - - - - - - - - - - -' 
      pp activated_models
      p ''
      activated_models_json = activated_models.to_json
      CacheService.get_instance.write("activated_models", activated_models.to_json)
    ensure
      @all_activated_models = JSON.parse(activated_models.to_json)
    end
  end

  def read
    @all_activated_models
  end

  def _clean_all_activated_aids(aids)
    aids.each do |aid|  
      aid.delete("created_at")
      aid.delete("updated_at")
      aid["filters"].each do |filter| 
        filter.delete("created_at")
        filter.delete("updated_at")
        filter.delete("name")
      end      
    end
    aids
  end

end