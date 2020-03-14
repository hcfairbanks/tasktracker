function preview_avatar(e){
  var input = $("#"+ e.id)[0];
  if ( input.files.item(0).size < 5100000 ){
    $("#cancel_button").css("display","inline")
    var fReader = new FileReader();
    fReader.readAsDataURL(input.files[0]);
    fReader.name = input.files[0].name;
    fReader.type = input.files[0].type;
    fReader.onloadend = function(event){
      var img = $("#avatar_img")[0];
      img.src = event.target.result;
    };
  }else{
    $("#file_input_avatar").val("");
    window.alert(I18n.t('user.avatar_less_then'));
  }
}

function cancel_avatar_upload(){
  $("#cancel_button").hide();
  var img = $("#avatar_img")[0];
  img.src = $.trim($("#original_avatar_source").html());
}

function check_pw_match(input) {
  if ($("#user_password_confirmation").val() != $("#user_password").val()) {
      input.setCustomValidity(I18n.t('pw_match'));
  } else {
      input.setCustomValidity('');
  }
}
