require 'rails_helper'
require 'support/gon_extraction_helper'

feature 'detail of a result page' do 

  HARKI_ITEM=".c-detail-condition-item.r_composed_be_a_harki1"
  ADULT_ITEM=".c-detail-condition-item.r_composed_be_an_adult4"
  QPV_ITEM=".c-detail-condition-item.r_composed_be_qpv3"

  context 'No active user' do
    
    before do
      asker = create(:asker, :fully_calculated_asker)
      aid = create(:aid, :aid_adult_or_harkis_or_qpv, name: 'ze_name_for_adult_or_harki')
      disable_http_service
      a = ConvertAskerInBase64Service.new.into_base64(asker)
      b = aid.slug
      visit detail_path(b)
    end
    after do
      enable_http_service
    end
    scenario 'Display the resume of the situation' do
      _display_resume_of_situation(false)
    end
  end

  context 'Active user, cache filled' do
    before do
      asker = create(:asker, :fully_calculated_asker)
      aid = create(:aid, :aid_adult_or_harkis_or_qpv, name: 'ze_name_for_adult_or_harki')
      disable_http_service
      cache_layer = instance_double("CacheService")
      allow(cache_layer).to receive(:read).and_return(SerializeResultsService.new(asker).go)
      CacheService.set_instance(cache_layer)

      a = ConvertAskerInBase64Service.new.into_base64(asker)
      b = aid.slug
      visit detail_path(b) + '?for_id=' + a
    end
    after do
      enable_http_service
      enable_cache_service
    end
    scenario 'Display all details correctly' do
      _display_resume_of_situation(true)
      _display_all_details_correctly
    end
  end

  context 'Active user, cache empty' do
    before do
      disable_http_service
      cache_service_returns_empty
      asker = create(:asker, :fully_calculated_asker)
      aid = create(:aid, :aid_adult_or_harkis_or_qpv, name: 'ze_name_for_adult_or_harki')

      a = ConvertAskerInBase64Service.new.into_base64(asker)
      b = aid.slug
      visit detail_path(b) + '?for_id=' + a
    end
    after do
      enable_http_service
      enable_cache_service
    end

    scenario 'Display all details correctly' do
      _display_resume_of_situation(true)
      _display_all_details_correctly
    end

  end

  def _display_resume_of_situation(should_display)
      if should_display
        expect(n(".c-detail-why")).to eq 1
      else
        expect(n(".c-detail-why")).to eq 0
      end
  end

  def _display_all_details_correctly
      expect(t('.c-detail-why--eligible')).to eq("Vous êtes éligible")
      expect(t("#{ADULT_ITEM} .c-detail-condition-text")).to eq("adult description")
      expect(t("#{HARKI_ITEM} .c-detail-condition-text")).to eq("harki description")
      expect(t("#{QPV_ITEM} .c-detail-condition-text")).to eq("qpv description")
      expect(find("#{HARKI_ITEM} svg")['class']).to include("error")
      expect(find("#{ADULT_ITEM} svg")['class']).to include("success")
      expect(find("#{QPV_ITEM} svg")['class']).to include("question")    
  end

end
