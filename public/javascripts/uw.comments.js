// UW.Comments

UW.setupNamespace("Comments");

UW.Comments.init = function(commentsPath){
  $('.comment a.edit').click(function(e){
    $(e.currentTarget).parents('.comment').children('.content').
    trigger('edit');
    e.preventDefault();
  });
  
  $('.comment .content a').live('click', function(e){
    window.open(e.target.href);
    return false;
  });
  
  $('.comment[data-editable=true]').each(function(i,el){
    id = $(el).attr('data-id');
    
    $(el).children(".content").click(function(e){
      if (e.target.tagName != "A")
        $(e.target).trigger('edit');
    });
  
    $(el).children(".content").editable(commentsPath + id, {
      type:      'textarea',
      method:    'PUT',
      indicator: 'Saving ...',
      cancel:    'Cancel',
      submit:    'Save',
      loadurl:   commentsPath + id,
      width:     '98%',
      event:     'edit',
      onblur:    'ignore',
      clicktoedit: false
    });
  });
}