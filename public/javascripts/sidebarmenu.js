var SidebarMenu = {};

SidebarMenu.register = function(sidebar){
  sidebarElement = $('#' + sidebar);
  
  sidebarElement.children('li').each(function(index, button){
    if(index == 0) $(button).children('a:first').addClass('selected');
       
    $(button).children('a:first').click(function(e){
      SidebarMenu.select(e.target);
      
      e.preventDefault();
    });
  });
  
  $('#bucket').children('div.bucket').hide();
  $('#bucket').children('div.bucket:first').show();
};

SidebarMenu.select = function(selected){
  selectedMenu = $(selected);
  
  selectedMenu.parents('ul').find('a.selected').removeClass('selected');
  selectedMenu.addClass('selected');
  
  $('#bucket').children('div.bucket').hide();
  
  selectedBucket = $(selectedMenu.attr('href'));
  selectedBucket.show();
};