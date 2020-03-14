function rm_attch(id,name,this_element){
  var conf = confirm( I18n.t('js.delete_doc_confirm_1') +
                      name +
                      I18n.t('js.delete_doc_confirm_2'))
  if (conf == true){
   rm_attch_ajax(id,this_element)
  }
}

function rm_attch_ajax(id,img_element){
  var url_text = "/delete_doc?id=" + id
  jQuery.ajax({
    url: url_text,
    type: "GET",
    dataType: "JSON",
    success: function (response) {
      li =  img_element.parentNode;
      li.parentNode.removeChild(li);
      update_priorities();
    },
    error: function(response){
      img_element.nextSibling.innerHTML = I18n.t('js.rm_doc_error');
    }
  });
}

function update_priorities(){
  var priority_num = 0
  var docs = $('#img_holder').find('img').map(function() {
    if ( this.className  == "doc" ){
      priority_num +=1
      return { id: $(this).attr("data-id"), priority: priority_num }
    }
  }).get()
  data = {attachment: {priorities_list: docs}}
  if ( priority_num > 0 ){
    jQuery.ajax({
      url: "/update_priorities/",
      type: "PUT",
      dataType: "JSON",
      data: data,
      success: function (response) {
        //console.log(response);
      },
      error: function(response){
        //console.log(response);
        alert(I18n.t('js.doc_sorting_error'));
      }
    });
  }
}

$(document).on('turbolinks:load', function() {
   $(".tasks.edit").ready(function(){
     init();
     $("#sortable").sortable();
   });

  function init() {
    var fileselect = $("#fileselect")[0],
        filedrag = $("#filedrag")[0],
        submitbutton = $("#submitbutton")[0];
    // file select
    fileselect.addEventListener("change", edit_file_select_handler, false);
    var xhr = new XMLHttpRequest();
    if (xhr.upload) {
      // file drop
      filedrag.addEventListener("dragover", edit_file_drag_hover, false);
      filedrag.addEventListener("dragleave", edit_file_drag_hover, false);
      filedrag.addEventListener("drop", edit_file_select_handler, false);
      filedrag.style.display = "block";
    }
  }

  function add_attachments(attachment_details, img_element, rm_btn_img){
    jQuery.ajax({
      url: "/attachments/",
      type: "POST",
      dataType: "JSON",
      data: {attachment: attachment_details},
      success: function (response) {
        rm_btn_img.onclick = function() { rm_attch( response.id,
                                                    response.original_name,
                                                    img_element) }
        img_element.setAttribute('data-id', response.id);
        img_element.src =  "/" + response.id + "/serve_thumb"
        img_element.className = "doc"
        var name_max_length = 9
        var display_name = response.original_name.substring(0, name_max_length)
        if (display_name.length >= name_max_length){
          display_name += "..."
        }
        img_element.nextSibling.innerHTML = display_name;
      },
      error: function(xhr){
        //console.log(xhr)
        img_element.nextSibling.innerHTML = I18n.t('js.upload_error');
        rm_btn_img.onclick = function() {
          li = rm_btn_img.parentNode;
          li.parentNode.removeChild(li);
        }
      }
    });
  }

  $("#sortable").sortable({
    stop: function( event, ui ) {
      update_priorities()
    }
  });

  // file drag hover
  function edit_file_drag_hover(e) {
    e.stopPropagation();
    e.preventDefault();
    if ( e.type == "dragover" ){
      $("#filedrag").css("border-color", "#f00");
    }else {
      $("#filedrag").css("border-color", "#555");
    }
  }

  function count_images(){
    var total_images = 0
    var docs = $('#img_holder').find('img').map(function() {
      if ( this.className  == "doc" ){
        total_images +=1
      }
    }).get()
    return total_images
  }

  //  file selection
  function edit_file_select_handler(e) {
  	edit_file_drag_hover(e);
  	var files = e.target.files || e.dataTransfer.files;
    var total_doc_count = count_images() + files.length;
    if (total_doc_count <= 10){
      for (var i = 0; i < files.length; ++i){
    	  reader = new FileReader();
    		reader.readAsDataURL( files[i] )
        reader.fileName = files[i].name
        reader.type = files[i].type;
        reader.fileArray = []
        reader.onload = function (event) {
          //  Document image
          evt = event.target
          doc_img = edit_create_doc_img(evt.result, evt.fileName, evt.type);
          //  Div displaying filename
          var file_name_div = edit_create_display_div();
          // Remove button
          var rm_btn_img = edit_create_rm_btn()
          //  Place elements on view
          edit_create_li(doc_img, file_name_div, rm_btn_img);
          var priority = count_images() + 1 ;
          var attachment = { doc:  event.target.result,
                             priority: priority ,
                             original_name: event.target.fileName,
                             task_id: $("#task_id").html()}
          add_attachments( attachment, doc_img, rm_btn_img );
        };
      }
    }else{
      $("#fileselect").val("");
      alert(I18n.t('js.max_attach'));
    }
  }
});

function edit_create_display_div(){
  var file_name_div = document.createElement("div");
  file_name_div.innerHTML = I18n.t('js.uploading');
  file_name_div.className = "file_title_sm"
  return file_name_div
}

function edit_create_rm_btn(){
  var rm_btn_img = document.createElement("img");
  rm_btn_img.src = "/site_images/red_x_1.png";
  rm_btn_img.className = "rm_btn"
  rm_btn_img.onmouseover = function() {this.src ='/site_images/red_x_2.png' }
  rm_btn_img.onmouseout = function() {this.src ='/site_images/red_x_1.png' }
  return rm_btn_img
}

function edit_create_li(doc_img, file_name_div, rm_btn_img){
  var ul = $("#sortable")[0];
  var li = document.createElement("li");
  li.appendChild(doc_img);
  li.appendChild(file_name_div)
  li.appendChild(rm_btn_img)
  ul.appendChild(li);
}

function edit_create_doc_img(base64_string, file_name, file_type){
  var image_types = ["image/jpeg","image/png"]
  var doc_img = document.createElement("img");
  doc_img.className = "doc"
  if ( image_types.includes(file_type) ){
    doc_img.src = base64_string;
  }else{
    doc_img.src = "/site_images/doc_thumb.jpg";
  }
  doc_img.setAttribute('data-img-name', file_name);
  doc_img.setAttribute('data-string', base64_string);
  doc_img.className = "doc_uploading"
  return doc_img
}
