// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


/*
  The BlindUp and BlindDown effects looked funky on my copy of Firefox, so I swapped them out for show/hide.
  This could be made a user-level option if one were so inclined...
*/
function expandable_toggle_links(id) {
  $(id + '_more_link').toggle();
  $(id + '_less_link').toggle();
}
function expandable_show_more(id) {
  expandable_toggle_links(id);
  $(id + '_less').hide();
  $(id + '_more').show();
  // new Effect.BlindUp(  id + '_less', {duration:0.25, queue:'end'});
  // new Effect.BlindDown(id + '_more', {duration:0.25, queue:'end'});
}
function expandable_show_less(id) {
  expandable_toggle_links(id);
  $(id + '_more').hide();
  $(id + '_less').show();
  // new Effect.BlindUp(  id + '_more', {duration:0.25, queue:'end'});
  // new Effect.BlindDown(id + '_less', {duration:0.25, queue:'end'});
}
