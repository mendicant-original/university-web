// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function isScrollBottom() {
  var documentHeight = $(document).height();
  var scrollPosition = $(window).height() + $(window).scrollTop();
  return (documentHeight == scrollPosition);
}