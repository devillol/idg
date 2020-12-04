// var startDateDef = new Date('2019-12-02');
// var endDateDef = new Date('2020-01-29');
//
// // var $start = $(".input-daterange").find('#date_from');
// // var $end = $(".input-daterange").find('#date_to');
//
// $(".input-daterange").datepicker({
//     orientation: "bottom auto",
//     format: 'yyyy-mm-dd',
//     weekStart: 1,
//     startDate: startDateDef,
//     endDate: endDateDef,
//     datesDisabled: [
//         '2019-12-20',
//         '2019-12-25',
//         '2020-01-04'
//     ],
//     todayHighlight: true,
//     clearBtn: true
// });

// $end.on('show', function(e){
//     var date = $start.datepicker('getDate');
//     // date = moment(date).toDate();
//     $end.datepicker('setStartDate', date);
// });

let trunc_csv_path = "";
let sma_csv_path = "";


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
    hideElement("sma");
    hideElement("download_box");
    var frame = document.getElementById("plotframe");
    frame.style.display = "none";
    // var system = document.getElementById("system").value;
    var date_from = document.getElementById("date_from").value;
    var date_to = document.getElementById("date_to").value;
    // var gr_min = document.getElementById("number-picker").value;
    // var fun = document.getElementById("function").value;
    $.post( "/lemi", {
        // "system": system,
        "date_from": date_from,
        "date_to": date_to,
        "act": "create_plot"
        // "gr_min": gr_min,
        // "function": fun
    }, function(data) {
        var filename = data["plt_path"];
        trunc_csv_path = data["csv_path"];
        var frame = document.getElementById("plotframe");
        frame.src = `/plots/${filename}`;
        frame.style.display = "block";
        hideElement("loader");
        showElement("sma");
        showElement("download_box");
        hideElement("sma_csv");
    });
};

function sma_plot() {
    showElement("loader");
    var frame = document.getElementById("plotframe");
    frame.style.display = "none";
    var plt_path = frame.src;

    $.post( "/lemi", {
            // "system": system,
            "csv_path": trunc_csv_path,
            "plt_path": frame.src,
            "act": "sma_plot"
            // "gr_min": gr_min,
            // "function": fun
        }, function(data) {
        sma_csv_path = data["csv_path"];
        var frame = document.getElementById("plotframe");
        frame.src = plt_path;
        hideElement("loader");
        showElement("sma_csv");
        frame.style.display = "block";
        });

};


function download_trunc() {
    // var arrayChecked = [];
    // $.each($("input[name='columns']:checked"), function(){
    //     arrayChecked.push($(this).val());
    // });
    var Bx = document.getElementById("Bx").checked;
    var By = document.getElementById("By").checked;
    var Bz = document.getElementById("Bz").checked;
    var Tin = document.getElementById("Tin").checked;
    var Tout = document.getElementById("Tout").checked;
    $.post("/lemi/download_trunc",
        {"csv_path": trunc_csv_path,
            "Bx": Bx,
            "By": By,
            "Bz": Bz,
            "Tin": Tin,
            "Tout": Tout
        },
        function(data){
            window.location = `/plots/${data["filename"]}`;
        });

};

function download_sma() {
    window.location = `/plots/${sma_csv_path}`;
};

