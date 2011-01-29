// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function isScrollBottom() {
  var documentHeight = $(document).height();
  var scrollPosition = $(window).height() + $(window).scrollTop();
  return (documentHeight == scrollPosition);
}

function enableTabs() {
  $(".tab_content").hide();
	$("ul.tabs li:first").addClass("active").show();
	$(".tab_content:first").show();

	$("ul.tabs li").click(function() {

		$("ul.tabs li").removeClass("active");
		$(this).addClass("active");
		$(".tab_content").hide();

		var activeTab = $(this).find("a").attr("href");
		$(activeTab).fadeIn();
		$.scrollTo('100%', { axis: 'y' });
		return false;
	});
	
	$('ul.tabs li a[href=#preview]').click(function(){
	  var converter = new Showdown.converter();
    var html = converter.makeHtml($('#edit.tab_content textarea').val());
    $('#preview').html(html);
	});
	
	$('.description a').live('click', function(e){
    window.open(e.target.href);
    return false;
	});
}