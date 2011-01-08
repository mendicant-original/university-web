var DropdownMenu = {};

DropdownMenu.register = function(name){
  $('#' + name + '_dropdown').hide();
  
  $('#' + name + ' a').click(function(e){
    DropdownMenu.toggle(name)

    // Allow clicking both on and off the menu to close it
    if($('#' + name + ' a').hasClass('active')){
      
      // TODO: Use namespaced click event
      // http://answers.oreilly.com/topic/2353-5-things-you-might-not-know-about-jquery/
      //
      $(document.body).click(function(e){
        if(!$(e.originalTarget).is('#' + name + ' a')){
          $(document.body).unbind('click');
          DropdownMenu.toggle(name);
        }
        else if($(e.originalTarget).is('#' + name + ' a') && !$(e.originalTarget).hasClass('active'))
          $(document.body).unbind('click');
      });
    }
      
    e.preventDefault();
  });
}

DropdownMenu.toggle = function(name){
  $('#' + name + '_dropdown').toggle(); 
  $('#' + name + ' a').toggleClass('active');
  
  // This should use a sprite
  if($('#' + name + ' a').hasClass('active'))
    $('#' + name + ' a img').attr('src', '/images/down_arrow_dark.png');
  else
    $('#' + name + ' a img').attr('src', '/images/down_arrow.png');
}