$(document).ready(function() {
    "use strict";
    $('.menu > ul > li:has( > ul)').addClass('menu-dropdown-icon');
    $('.menu > ul > li > ul:not(:has(ul))').addClass('normal-sub');
    $(".menu > ul").before("<a href=\"#\" class=\"menu-mobile\">&nbsp;</a>");
    $(".menu > ul > li").hover(function(e) {
        if ($(window).width() > 943) {
            $(this).children("ul").stop(true, false).fadeToggle(150);
            e.preventDefault();
        }
    });
    $(".menu > ul > li").click(function() {
        if ($(window).width() <= 943) {
            $(this).children("ul").fadeToggle(150);
        }
    });
    $(".menu-mobile").click(function(e) {
        $(".menu > ul").toggleClass('show-on-mobile');
        e.preventDefault();
    });
});
$(window).resize(function() {
    $(".menu > ul > li").children("ul").hide();
    $(".menu > ul").removeClass('show-on-mobile');
});


function showElement(elementId){
    var el = document.getElementById(elementId);
    el.style.display = "block";
};
function hideElement(elementId){
    var el = document.getElementById(elementId);
    el.style.display = "none";
};
// function tuggle_number_picker(elm){
//     var picker = document.getElementById("number-picker-block");
//     var aggfun = document.getElementById("function-block");
//     if (elm.value == "spectr"){
//         picker.style.display = "none";
//         aggfun.style.display = "none";
//     }else{
//         picker.style.display = "block";
//         aggfun.style.display = "block";
//     };
//
// };

function create_plot(){
    // show_loader();
    // hide_sma();
    showElement("loader");
    var frame = document.getElementById("plotframe");
    frame.style.display = "none";
    // var system = document.getElementById("system").value;
    var date_from = document.getElementById("date_from").value;
    var date_to = document.getElementById("date_to").value;
    // var gr_min = document.getElementById("number-picker").value;
    // var fun = document.getElementById("function").value;
    $.post( "/spectr", {
        // "system": system,
        "date_from": date_from,
        "date_to": date_to,
        "act": "create_plot"
        // "gr_min": gr_min,
        // "function": fun
    }, function(data) {
        var filename = data["plt_path"];
        var frame = document.getElementById("plotframe");
        frame.src = `/plots/${filename}`;
        frame.style.display = "block";
        hideElement("loader");
    });
};



