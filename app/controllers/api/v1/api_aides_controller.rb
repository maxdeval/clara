module Api
  module V1
    class ApiAidesController < Api::V1::ApiController

      before_action :authenticate_user

      def index
        if current_user
          # asker = Asker.new(asker_params)
          asker = TranslateAskerService.new(english_asker).to_french
          result = SerializeResultsService.new(asker).jsonify
          render json: result
        end
      end

      def asker_params
        params.permit(:v_handicap, :v_harki, :v_detenu, :v_protection_internationale, :v_diplome, :v_category, :v_duree_d_inscription, :v_allocation_value_min, :v_allocation_type, :v_location_label, :v_qpv, :v_zrr, :v_age, :v_location_citycode, :v_location_country, :v_location_label, :v_location_route, :v_location_state, :v_location_street_number, :v_location_zipcode).to_h
      end


      def english_asker
        params.permit(:disabled, :harki, :ex_invict, :international_protection, :diploma, :category, :inscrition_period, :monthly_allocation, :allocation_type, :age).to_h
      end


    end
  end
end
