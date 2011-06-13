// UW.Submissions

UW.setupNamespace("Submissions");

var initDescription = function(path){
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

    var placeholder = "<div id='placeholder'>Click 'Edit' to update your " +
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
};

var initGithub = function(path){
    var editGithubPath = path + '/associate_with_github';

    $('#edit_github').click(function(){
      $('#submission_github').trigger("edit");
    });

    $('#submission_github').click(function(e){
      if (e.target.tagName != "A")
        $(e.target).trigger('edit');
    }).
    bind('edit', function(){ $('#github_controls').hide(); }).
    bind('cancel', function(){ $('#github_controls').show(); });

    var placeholder = "<div id='placeholder'>Click 'Edit' to update your " +
    "submission's github repository.</div>";

    var onGithubReset = function(){ $('#github_controls').show(); };

    $('#submission_github').editable(editGithubPath, {
        type:        'textarea',
        data:        function(value, options) { return ''; },
        height:      '20px',
        width:       '98%',
        indicator:   'Saving ...',
        cancel:      'Cancel',
        submit:      'Save',
        tooltip:     "Click 'Edit' to make changes",
        event:       'edit',
        placeholder: placeholder,
        onblur:      'ignore',
        clicktoedit: false,
        onreset:     onGithubReset,
        callback:    onGithubReset
    });
};

UW.Submissions.init = function(path, editable){
  if(editable){
      initDescription(path);
      initGithub(path);
  }
  
  $('form.edit_assignment_submission').submit(function(e){
    if($('#comment_comment_text').val() != ""){
      if(confirm("You've started working on a comment.\n\n" +
                 "Click OK to continue and discard your comment.") == false)
        e.preventDefault();
    }
  });
}