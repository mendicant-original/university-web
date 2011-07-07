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

  $('.comment a.reply').click(function(e){
    var reply_container = $("form.new_comment #in_reply_to"),
        comment         = $(this).closest('.comment'),
        id              = comment.attr('data-id'),
        index           = comment.attr('id');

    reply_container.find("input[type='hidden']").val(id);
    reply_container.find("a:first").attr('href', '#' + index)
                                    .text('Comment #' + index);
    reply_container.show();
    $("form.new_comment textarea").focus();
  });

  $('form.new_comment #in_reply_to a.cancel_reply').click(function(e){
    var reply_container = $("form.new_comment #in_reply_to");
    reply_container.find("input[type='hidden']").val('');
    reply_container.fadeOut();
    return false;
  });
}
