// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function(){
    $(window).scroll(function (){
//        $("#header").css("top", $(window).scrollTop());
//        track_info_site();
    });
    function track_info_site() {
//        var offsetTop = $(window).scrollTop() + ($(window).height()-$("#track_info").height()) / 2;
//        $("#track_info").animate({top : offsetTop},{duration:500 , queue:false});

        $("#header").css("top", $(window).scrollTop());
//        $("#header").animate({top : $(window).scrollTop()},{duration:0 , queue:false});
    }
})
