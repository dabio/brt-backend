//= require ender.min

// replace encoded emails
$('a.email').each(function(el) {
  if (!el.innerHTML) return !1;
  var email = el.innerHTML.replace(' . ', '.').replace(' [at] ', '@');
  el.href = 'mailto:'+email;
  el.innerHTML = email;
});
/*
// edit link
$('a.edit').click(function(el) {
  var a = new Array(
        $('.news-item'),
        $('.news-item-aside'),
        $('.news-form'),
        $('.news-form-aside')
      ),
      i;

  for (i=0; i < a.length; i++) {
    a[i].toggle(function(){}, 'block');
  }

});

// delete link
$('a.delete').click(function(el) {
  alert('delete');
});

// button submit
//$('.news-form button').click(function(el) {
//  el.preventDefault();el.stopPropagation();
//  //$('form')
//  //$.ajax();
//});
*/
