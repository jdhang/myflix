jQuery(function($) {
  $('#new_user').submit(function(event) {
    var $form = $(this);
    $form.find('.register_submit').prop('disabled', true);
    Stripe.createToken({
      number: $('#cc_number').val(),
      cvc: $('#cc_cvc').val(),
      exp_month: $('#cc_exp_month').val(),
      exp_year: $('#cc_exp_year').val()
    }, stripeResponseHandler);
    return false;
  });

  var stripeResponseHandler = function(status, response) {
    var $form = $('#new_user');

    if (response.error) {
      $form.find('.register-errors').text(response.error.message);
      $form.find('.register_submit').prop('disabled', false);
    } else {
      var token = response.id;
      $form.append($('<input type="hidden" name="stripeToken" />').val(token));
      $form.get(0).submit();
    }
  };
});
