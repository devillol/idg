module SpectrController
  using Genie.Renderer.Html, Genie.Renderer.Json, CreatePlots, Genie.Requests, Statistics, Dates

  function main()
      pattern = r"(\d{4}-\d{2}-\d{2}).*"
      files = vcat([f for (r,d,f) in walkdir("$(ENV["SOURCE_DATA_PATH"])/SPECTR") if f!= [".DS_Store"]]...)
      dates = [d[1] for d in match.(pattern, files)]

      min_d = minimum(dates)
      max_d = maximum(dates)
      dates_disabled = ["'$(string(d))'" for d=Date(min_d):Day(1):Date(max_d) if !(string(d) in dates)]

        datepicker = "
  var startDateDef = new Date('$min_d');
var endDateDef = new Date('$max_d');
 \$('.input-daterange').datepicker({
    orientation: 'bottom auto',
    format: 'yyyy-mm-dd',
    weekStart: 1,
    startDate: startDateDef,
    endDate: endDateDef,
    datesDisabled: [$(join(dates_disabled, ","))],
    todayHighlight: true,
    clearBtn: true
});
"
    open("$(ENV["APP_PATH"])/public/js/spectr_dp.js", "w") do f
        write(f, datepicker)
    end
    html(:spectr, :spectr, frame = "", layout = :spectr)
  end
  function frame()
    act = postpayload(:act)
    if act == "create_plot"
        date_from = postpayload(:date_from, "2019-12-22")
        date_to = postpayload(:date_to, "2019-12-22")

        files_dict = CreatePlots.create_spectr(date_from, date_to, "$(ENV["APP_PATH"])/public/plots")
        return json(Dict("plt_path" => basename(files_dict["plt_path"])))
      end
  end
end

