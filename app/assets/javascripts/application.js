// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require bootstrap
//= require turbolinks
//= require_tree .
$(document).ready(function() {
    var source = new EventSource('/stream');
    source.addEventListener('bookcreated', function(e) {
         if (e.data=="book") {
             if (/$/.test(location.pathname)){
                 location.reload();
             }
         }
         else if (e.data=="show") {
        if (/.bills.show/.test(location.pathname)){
            location.reload();
        }
        else if (/$/.test(location.pathname)){
            if($('#proc').length==0){
                $("#Book").find("tr:eq(1)").append('<div id="proc"><img src="/assets/ajax-loader.gif" width="25" height="25" alt="Edit Entry" /></div>');
            }
        }

    }
         else if (e.data=="finish") {
             if (/$/.test(location.pathname)){
                 location.reload();
                 $("#proc").remove();
             }
         }
    });
});



