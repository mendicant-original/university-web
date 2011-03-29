UW.setupNamespace("Admissions");

UW.Admissions.enableStatusUpdating = function(editPath, loadPath){
  $('.submision_status').each(function(i,el){
    id = $(el).attr('data-id');

    $(el).editable(editPath + id, {
      type:      'select',
      method:    'PUT',
      indicator: 'Saving ...',
      cancel:    'Cancel',
      submit:    'Save',
      loadurl:   loadPath,
      onblur:    'ignore'
    });
  });
}