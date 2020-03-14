$(document).on('turbolinks:load', function() {
  $(".tasks.new").ready(function(){
    init();
    $("#sortable").sortable({
      stop: function( event, ui ) {}
    });
  });

  $("#new_task").submit(function() {
    $("#task_sub_btn").prop("disabled",true);
    $("#upload_notices").removeClass("upload_error");
    $("#upload_notices").addClass("uploading");
    $("#upload_notices").html(I18n.t("js.uploading"));
    var data = {};
    $("#new_task").serializeArray().map(function(x){data[x.name] = x.value;});
    data["task[attachments_attributes]"] = create_docs_array();

    jQuery.ajax({
      url: "/tasks/",
      type: "POST",
      dataType: "JSON",
      data: data,
      success: function (response) {
        window.location.href = "/tasks/" +
                                response.id +
                                "?notice=" +
                                I18n.t("task.created");
      },
      error: function(response){
        $("#upload_notices").removeClass("uploading_dots");
        $("#upload_notices").addClass("upload_error");
        $("#upload_notices").html(I18n.t("js.upload_error"));
        $("#task_sub_btn").prop("disabled",false);;
        alert(I18n.t("js.task_create_error"));
      }
    });
    return false;
  });

  function create_docs_array(){
    var docs = $('#img_holder').find('img').map(function() {
      if ( this.className  == "doc" ){
        return { source: $(this).attr("data-string"),
                 original_name: $(this).attr("data-img-name")}
      }
    }).get()
    var docs_array = []
    for (var i = 0; i < docs.length; ++i){
      docs_array.push( { doc: docs[i]["source"] ,
                         original_name: docs[i]["original_name"],
                          priority: i } )
    }
    return docs_array
  }

 function init() {
   var fileselect = $("#fileselect")[0],
       filedrag = $("#filedrag")[0],
       submitbutton = $("#submitbutton")[0];
   // file select
   fileselect.addEventListener("change", new_file_select_handler, false);
   var xhr = new XMLHttpRequest();
   if (xhr.upload) {
     // file drop
     filedrag.addEventListener("dragover", new_file_drag_hover, false);
     filedrag.addEventListener("dragleave", new_file_drag_hover, false);
     filedrag.addEventListener("drop", new_file_select_handler, false);
     filedrag.style.display = "block";
   }
 }

  // file drag hover
  function new_file_drag_hover(e) {
    e.stopPropagation();
    e.preventDefault();
    if ( e.type == "dragover" ){
      $("#filedrag").css("border-color", "#f00");
    }else {
      $("#filedrag").css("border-color", "#555");
    }
  }

  // file selection
  function new_file_select_handler(e) {
    var image_types = ["image/jpeg","image/png"]
  	new_file_drag_hover(e);
  	var files = e.target.files || e.dataTransfer.files;
    if (files.length <= 10){
      for (var i = 0; i < files.length; ++i){
      	reader = new FileReader();
    		console.log( reader.readAsDataURL( files[i] ) )
        reader.fileName = files[i].name
        reader.type = files[i].type;
        reader.fileArray = []
        reader.onload = function (event) {
          //  Document image
          evt = event.target
          doc_img = new_create_doc_img(evt.result, evt.fileName, evt.type);
          //  Div displaying filename
          name_max_length = 9;
          var file_name_div = new_create_display_div(evt.fileName, name_max_length);
          // Remove button
          var rm_btn_img = new_create_rm_btn()
          //  Place elements on view
          new_create_li(doc_img, file_name_div, rm_btn_img);
  		  };
      }
    }else{
      $("#fileselect").val("");
      alert(I18n.t('js.max_attach'));
    }
  }
});

function new_create_display_div(file_name, name_max_length){
  var file_name_div = document.createElement("div");
  var display_name = file_name.substring(0, name_max_length)
  if (display_name.length >= name_max_length){
    display_name += "..."
  }
  file_name_div.innerHTML = display_name;
  file_name_div.className = "file_title_sm";
  return file_name_div
}

function new_create_rm_btn(){
  var rm_btn_img = document.createElement("img");
  rm_btn_img.src ="/site_images/red_x_1.png";
  rm_btn_img.className = "rm_btn"
  rm_btn_img.onmouseover = function() {this.src ="/site_images/red_x_2.png" }
  rm_btn_img.onmouseout = function() {this.src ="/site_images/red_x_1.png" }
  rm_btn_img.onclick = function(){
    li = rm_btn_img.parentNode;
    li.parentNode.removeChild(li);
  }
  return rm_btn_img
}

function new_create_li(doc_img, file_name_div, rm_btn_img){
  var ul = $("#sortable")[0];
  var li = document.createElement("li");
  li.appendChild(doc_img);
  li.appendChild(file_name_div)
  li.appendChild(rm_btn_img)
  ul.appendChild(li);
}

function new_create_doc_img(base64_string, file_name, file_type){
  var image_types = ["image/jpeg","image/png"]
  var doc_img = document.createElement("img");
  doc_img.className = "doc"
  if ( image_types.includes(file_type) ){
    doc_img.src = base64_string;
  }else{
    doc_img.src = "/site_images/doc_thumb.jpg";
  }
  doc_img.setAttribute("data-img-name", file_name);
  doc_img.setAttribute("data-string", base64_string);
  doc_img.className = "doc"
  return doc_img
}
