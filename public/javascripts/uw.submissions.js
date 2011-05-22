// UW.Submissions

UW.setupNamespace("Submissions");

UW.Submissions.init = function(path, editable){
  if(editable){
    var editPath = path + '/description';
  
    $('#edit_description').click(function(){
      $('#submission_description').trigger("edit");
    });
  
    $('#submission_description').click(function(e){
      if (e.target.tagName != "A") 
        $(e.target).trigger('edit');
    }).
    bind('edit', function(){ $('#description_controls').hide(); }).
    bind('cancel', function(){ $('#description_controls').show(); });
  
    placeholder = "<div id='placeholder'>Click 'Edit' to update your " +
    "submission's description.</div>Comments on your submission go below.";
  
    var onReset = function(){ $('#description_controls').show(); };
  
    $('#submission_description').editable(editPath, {
      type:        'textarea',
      height:      '200px',
      width:       '98%',
      indicator:   'Saving ...',
      cancel:      'Cancel',
      submit:      'Save',
      loadurl:     path + '.text',
      tooltip:     "Click 'Edit' to make changes",
      event:       'edit',
      placeholder: placeholder,
      onblur:      'ignore',
      clicktoedit: false,
      onreset:     onReset,
      callback:    onReset
    });
  }
  
  $('form.edit_assignment_submission').submit(function(e){
    if($('#comment_comment_text').val() != ""){
      if(confirm("You've started working on a comment.\n\n" +
                 "Click OK to continue and discard your comment.") == false)
        e.preventDefault();
    }
  });
}