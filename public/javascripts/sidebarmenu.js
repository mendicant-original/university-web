var SidebarMenu = {};

SidebarMenu.register = function(sidebar){
  sidebarElement = $('#' + sidebar);
  
  sidebarElement.children('li').each(function(index, button){
    $(button).children('a:first').click(function(e){
      SidebarMenu.select(e.target);
      
      e.preventDefault();
    });
  });
  
  $('#bucket').children('div.bucket').hide();
  
  url = document.location.toString();
  
  if(url.match('#')){
    selected = $('a[data-id=' + url.split('#')[1] + ']');
    SidebarMenu.select(selected);
  }
  else{
    SidebarMenu.select(sidebarElement.find('li:first a:first'));
  }
};

SidebarMenu.select = function(selected){
  selectedMenu = $(selected);
  
  selectedMenu.parents('ul').find('a.selected').removeClass('selected');
  selectedMenu.addClass('selected');
  
  $('#bucket').children('div.bucket').hide();
  
  selectedBucket = $('#' + selectedMenu.attr('data-id'));
  selectedBucket.show();
  
  $('#current_section').text(selectedMenu.text());
  window.location.hash = selectedMenu.attr('data-id');
};