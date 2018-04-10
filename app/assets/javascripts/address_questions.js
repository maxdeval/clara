$(document).on('ready turbolinks:load', function() {
  if ($('body').hasClass('address_questions', 'new')) {

    /* Autocomplete
    ––––––––––––––––––––––––––––––––––––––––––––––––––*/
    function initializeAutocomplete(id) {
      var element = document.getElementById(id);
      if (element) {
        var autocomplete = new google.maps.places.Autocomplete(element, { types: ['geocode'] });
        autocomplete.setComponentRestrictions({'country': ['fr', 'bl', 'mf']});
        google.maps.event.addListener(autocomplete, 'place_changed', onPlaceChanged);
      }
    }
    
    function onPlaceChanged() {
      var place = this.getPlace();

      var postcode = _.get(_.first(_.filter(place.address_components, function(e) {return _.includes(e.types, "postal_code")})), 'long_name');

      $("input.js-next").prop('disabled', true);

      $.get({
        url: window.clara.env.ARA_URL_BAN + place.formatted_address + '&postcode=' + postcode,
        success: function(e) {
          // console.log(e) 
          $("input.js-next").prop('disabled', false);
          var citycode = _.get(e, "features[0].properties.citycode")
          $('input#citycode').val(citycode);
        },
        error: function(e) {
          $("input.js-next").prop('disabled', false);
                    
        },
        timeout:2003
      });


      console.log(place);  // Uncomment this line to view the full object returned by Google API.

      _.each(place.address_components, function (address_component){
        var input_target = address_component.types[0];
        $('input#' + input_target).val(address_component.long_name);
      });

    }
    

    initializeAutocomplete("search")

    /* Encourage
    ––––––––––––––––––––––––––––––––––––––––––––––––––*/
    if (PNotify && localStorage && _.isEmpty(localStorage.getItem("soon_finished_info"))) {
     localStorage.setItem("soon_finished_info", "true");
     setTimeout(function(){
       PNotify.removeAll();
       new PNotify({
        title: 'Plus que 2 questions',
        type: 'info',
        buttons:{
          sticker: false,
        },
        text: "Plus que 2 questions et vous obtenez vos résultats (celle-ci est facultative)"
      });
     }, 500);
   }

 }
});
