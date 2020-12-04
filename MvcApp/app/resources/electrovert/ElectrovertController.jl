module ElectrovertController
  using Genie.Renderer.Html, Genie.Renderer.Json, CreatePlots, Genie.Requests, Statistics, Dates

  function main()
      pattern = r"electrovert\.(\d{4}-\d{2}-\d{2})\.csv"
      files = vcat([f for (r,d,f) in walkdir("$(ENV["SOURCE_DATA_PATH"])/ELECTROVERT") if f!= [".DS_Store"]]...)
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
    open("$(ENV["APP_PATH"])/public/js/electrovert_dp.js", "w") do f
        write(f, datepicker)
    end
    html(:electrovert, :electrovert, frame = "", layout = :electrovert)
  end
  function frame()
    act = postpayload(:act)
    if act == "create_plot"
        date_from = postpayload(:date_from, "2019-12-22")
        date_to = postpayload(:date_to, "2019-12-22")

        files_dict = CreatePlots.create_plot("electrovert",date_from, date_to, "$(ENV["APP_PATH"])/public/plots")
        return json(Dict("plt_path" => basename(files_dict["plt_path"]), "csv_path" => basename(files_dict["csv_path"])))
     elseif act == "sma_plot"
         csv_path = postpayload(:csv_path)
          plt_path = postpayload(:plt_path)
          files_dict = CreatePlots.sma_plot("$(ENV["APP_PATH"])/public/plots/$(basename(csv_path))",
                    "$(ENV["APP_PATH"])/public/plots/$(basename(plt_path))")
          return json(Dict("plt_path" => basename(files_dict["plt_path"]), "csv_path" => basename(files_dict["csv_path"])))
      end
  end
  macro Name(arg)
          string(arg)
          end

   function trunc()
      I1 = postpayload(:I1) == "true" ? "I1" : missing
      I2 = postpayload(:I2) == "true" ? "I2" : missing
      csv_path = postpayload(:csv_path)
      arrayChecked = [p for p in [I1, I2] if !ismissing(p)]
      files_dict = CreatePlots.download_trunc(arrayChecked, "$(ENV["APP_PATH"])/public/plots/$(basename(csv_path))")
      return json(Dict("filename" => basename(files_dict["filename"])))
    end
end

