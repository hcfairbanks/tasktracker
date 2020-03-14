$(document).on('turbolinks:load', function(){
   $('#datepicker').datepicker({ dateFormat: 'dd-mm-yy' });
   $(".clickable-td").click(function(){
      window.location = $(this).parents().data('href');
   });
});

function show(comment_id) {
  var $button_id = "#"+"edit_" + comment_id
  $("#" + comment_id).toggle();
  $($button_id).text($($button_id).text() == I18n.t('edit') ? I18n.t('cancel') : I18n.t('edit') );
  text_area_var = document.getElementById('comment_content_' + comment_id);
  if (text_area_var.style.display == "none"){
    text_area_var.style.display = "block";
  }else{
    text_area_var.style.display = "none";
  }
  return false;
};
