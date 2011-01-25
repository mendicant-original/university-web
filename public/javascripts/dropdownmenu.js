var DropdownMenu = {};

DropdownMenu.register = function(name){
  $('#' + name + '_dropdown').hide();
  
  $('#' + name + ' a:first').click(function(e){    
    DropdownMenu.toggle(name)

    // Allow clicking both on and off the menu to close it
    if($('#' + name + ' a').hasClass('active')){
      $(document.body).bind('click.dropdown.' + name, function(e){
        if(!$(e.target).is('#' + name + ' a')){
          $(document.body).unbind('.dropdown.' + name);
          DropdownMenu.toggle(name);
        }
        else if($(e.target).is('#' + name + ' a') && !$(e.target).hasClass('active'))
          $(document.body).unbind('.dropdown.' + name);
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