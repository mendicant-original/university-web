$(function() {

  $('#group_mail_group_type').change(function() {
    adjustGroupSelect();
  });
  
  $("#group_mail_group_id").change(function() {
    $("#group_mail_recipients").val("");
    var group_id = $(this).val();
    var group_type = $('#group_mail_group_type').val();
    populateRecipients(group_type, group_id);
  });
  
});

function populateRecipients(group_type, group_id) {
  $.get('/admin/group_mails/user_emails.text',
    { group_type: group_type,
      group_id: group_id },
    function(data){
      $("#group_mail_recipients").val(data);
    });
};

function adjustGroupSelect() {
  var group_type = $('#group_mail_group_type').val();
  
  // reset dependent inputs
  $("#group_mail_recipients").val("");
  $("#group_mail_group_id").emptySelect();
  $("#group_mail_group_id").attr("disabled", true);
  
  switch(group_type) {
    case '':
      break;
    case 'All':
      populateRecipients("All");
      break;
    default:
      $.getJSON('/admin/group_mails/update_group_select.json',
        { group_type: group_type },
        function(data){
          $("#group_mail_group_id").attr("disabled", false);
          $("#group_mail_group_id").loadSelect(data);
        });
      break;
  };
};


$.fn.emptySelect = function() { 
  return this.each(function(){ 
    if (this.tagName=='SELECT') {
      this.options.length = 0;
    }; 
  }); 
};

$.fn.loadSelect = function(optionsDataArray) {
return this.emptySelect().each(function(){ 
    if (this.tagName=='SELECT') { 
      var selectElement = this; 
      $.each(optionsDataArray, function(index,optionData) { 
        var option = new Option(optionData.caption, optionData.value); 
        if ($.browser.msie) { 
          selectElement.add(option); 
        } 
        else { 
          selectElement.add(option,null); 
        } 
      }); 
    } 
  }); 
};
