function show_loader(){
    var loader = document.getElementsByClassName("loader")[0];
    loader.style.display = "block";
  };

  function hide_loader(){
    var loader = document.getElementsByClassName("loader")[0];
    loader.style.display = "none";
  };

  function tuggle_number_picker(elm){
    var picker = document.getElementById("number-picker-block");
    var aggfun = document.getElementById("function-block");
    if (elm.value == "spectr"){
      picker.style.display = "none";
      aggfun.style.display = "none";  
    }else{
      picker.style.display = "block";
      aggfun.style.display = "block";
    };
   
  };

  function create_plot(){
    show_loader();
    var frame = document.getElementById("mainframe");
    frame.style.display = "none";
    var system = document.getElementById("system").value;
    var date_from = document.getElementById("date_from").value;
    var date_to = document.getElementById("date_to").value;
    var gr_min = document.getElementById("number-picker").value;
    var fun = document.getElementById("function").value;
    $.post( "/", {
      "system": system,
      "date_from": date_from,
      "date_to": date_to,
      "gr_min": gr_min,
      "function": fun
    }, function(data) {
      var filename = data["file"];
      var frame = document.getElementById("mainframe");
      frame.src = `/plots/${filename}`;
      frame.style.display = "block";
      hide_loader();
    });
  }