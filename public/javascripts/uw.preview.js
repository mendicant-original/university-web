$(document).ready(function(){
	$("textarea[data-preview=true]").each(function(index) {
		buildPreviewTab($(this));
	});

	// override tab clicks
	$('a.tab').live('click', function() {
		var tabs = $(this).parents('ul').find('li');
		var tab_contents = $(this).parents('ul').next('.tab_container').find('.tab_content');

		tabs.removeClass("active");
		$(this).parent().addClass("active");
		tab_contents.hide();

		// convert markdown for preview
		var html = convertMarkdown(tab_contents.find('textarea').val());
    tab_contents.filter('#preview').html(html);

		// show active tab contents
		var activeTab = tab_contents.filter($(this).attr("href"));
		$(activeTab).fadeIn();

		// why are we doing this?
		// $.scrollTo('100%', { axis: 'y' });
		return false;
	});

	// override links in preview
	$('#preview a').live('click', function(e){
    window.open(e.target.href);
    return false;
	});
});

function buildPreviewTab(textarea) {
	// insert tabs
	textarea.before(' \
		<ul class="tabs"> \
			<li><a class="tab" href="#edit">Edit</a></li> \
			<li><a class="tab" href="#preview">Preview</a></li> \
		</ul> \
	');

	// wrap textarea
	textarea.wrap('<div class="tab_content" id="edit" />');

	// tab_container wrapper
	textarea.parent().wrap('<div class="tab_container" />');

	// create #preview as a sibling as #edit
	textarea.parent().after('<div id="preview" class="tab_content description">Preview</div>');

	// activate tab links
	enableTabs(textarea);
}

function enableTabs(textarea) {
	var tabs = textarea.parents('.tab_container').prev('ul.tabs').find('li');
	var tab_contents = textarea.parents('.tab_container').find('.tab_content');

	tab_contents.hide();

	// show first tab
	tabs.first().addClass("active").show();
	tab_contents.first().show();
}

function convertMarkdown(text) {
	var converter = new Showdown.converter();
	return converter.makeHtml(text);
}