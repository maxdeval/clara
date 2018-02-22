require 'uri'

class QuestionManager
   include Rails.application.routes.url_helpers

  def getPreviousPath(referer)
  
    from = URI(referer).path
    func_name = from[ from.index('/')+1 .. from.rindex('_')-1 ]
    self.public_send('before_' + func_name)
  
  end

  def getNextPath(*args)
  
    if args.empty?
      after_default
    else
      referer = args[0]
      form = args[1]
      from = URI(referer).path
      func_name = from[ from.index('/')+1 .. from.rindex('_')-1 ]
      self.public_send('after_' + func_name, form)
    end
  
  end

  def after_default
    new_inscription_question_path
  end

  def after_inscription(inscriptionForm)
    inscriptionForm.value != 'non_inscrit' ? new_category_question_path : new_allocation_question_path
  end

  def after_category(categoryForm)
    new_allocation_question_path
  end

  def after_allocation(allocationForm)
    if allocationForm.type == 'ASS_AER_ATA_APS_AS-FNE' || allocationForm.type == 'ARE_ASP'
      new_are_question_path
    else
      new_age_question_path
    end
  end

  def after_are(areForm)
    new_age_question_path
  end

  def after_age(ageForm)
    new_grade_question_path
  end  

  def after_grade(ageForm)
    new_address_question_path
  end  
  
  def after_address(addressForm)
    new_other_question_path
  end

  def after_other(asker_id)
    aides_path + '?for_id=' + asker_id
  end 

  def before_other
    new_address_question_path
  end 

  def before_address
    new_grade_question_path
  end

  def before_grade
    new_age_question_path
  end 

  def before_age
    new_allocation_question_path
  end

  def before_inscription
    root_path
  end

  def before_category
    new_inscription_question_path
  end

  def before_allocation
    new_inscription_question_path
  end

  def before_are
    new_allocation_question_path
  end

end
