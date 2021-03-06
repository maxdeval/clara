class JustificationService

  def initialize(aid)
    @aid = aid
  end

  def root_rules
    if @aid != nil && @aid.rule != nil
      return @aid.rule.slave_rules if @aid.rule.is_complex_rule?
      return [@aid.rule] if @aid.rule.is_simple_rule?
    end
    []
  end

  def root_condition
    if @aid != nil && @aid.rule != nil
      return 'and' if @aid.rule.composition_type == 'and_rule'    
      return 'or' if @aid.rule.composition_type == 'or_rule'    
      return 'one' if @aid.rule.is_simple_rule?    
    end
    ''
  end

end
