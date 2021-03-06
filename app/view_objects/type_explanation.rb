class TypeExplanation < ViewObject

  def after_init(args)
    locals = hash_for(args)
    @number_of_aids = integer_for(locals[:number_of_aids])
    @business_id = string_for(locals[:business_id])
  end

  def has_text
    return full_text != "" && @number_of_aids > 0
  end

  def number_of_aids
    @number_of_aids
  end

  def full_text
    case @business_id
    when "projet-pro"
      "<div>Vous pouvez vérifier votre éligibilité à <strong><span class='aid-nb-txt'>#{number_of_aids} aides</span></strong> à la définition du projet professionnel.</div>".html_safe
    when "creation-reprise-entreprise"
      "<div>Vous pouvez vérifier votre éligibilité à <strong><span class='aid-nb-txt'>#{number_of_aids} aides</span></strong> à la création ou reprise d'entreprise.</div>".html_safe
    when "amob"
      "<div>Vous pouvez vérifier votre éligibilité à <strong><span class='aid-nb-txt'>#{number_of_aids} aides</span></strong> à la mobilité.</div>".html_safe
    when "alternance"
      "<div>Vous pouvez vérifier votre éligibilité à <strong><span class='aid-nb-txt'>#{number_of_aids} aides</span></strong> à l'alternance.</div>".html_safe
    else 
      ""
    end
  end

end
