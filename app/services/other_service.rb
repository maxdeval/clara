class OtherService

  def initialize(asker)
    @asker = asker
  end

  def download_from_asker
    other = OtherForm.new
    other.val_spectacle =  @asker.v_spectacle         
    other.val_handicap =  @asker.v_handicap
    if @asker.v_spectacle == 'non' && @asker.v_handicap == 'non'
        other.none = 'oui'
    end
    other
  end

  def upload_to_asker(other)
    @asker.v_spectacle  = other.val_spectacle.nil?    ? 'non':'oui'
    @asker.v_handicap   = other.val_handicap.nil? ? 'non':'oui'
  end

end
