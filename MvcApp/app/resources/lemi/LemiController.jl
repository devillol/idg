module LemiController
  using Genie.Renderer.Html, Genie.Renderer.Json, CreatePlots, Genie.Requests, Statistics
  function main()
    html(:lemi, :lemi, frame="", layout=:lemi)
  end
  function frame()
    act = postpayload(:act)
    if act == "create_plot"
        date_from = postpayload(:date_from, "2019-12-22")
        date_to = postpayload(:date_to, "2019-12-22")

        files_dict = CreatePlots.create_plot("lemi018",date_from, date_to, "$(ENV["APP_PATH"])/public/plots")
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
      Bx = postpayload(:Bx) == "true" ? "Bx" : missing
      By = postpayload(:By) == "true" ? "By" : missing
      Bz = postpayload(:Bz) == "true" ? "Bz" : missing
      Tin = postpayload(:Tin) == "true" ? "Tin" : missing
      Tout = postpayload(:Tout) == "true" ? "Tout" : missing
      csv_path = postpayload(:csv_path)
      arrayChecked = [p for p in [Bx, By, Bz, Tin, Tout] if !ismissing(p)]
      files_dict = CreatePlots.download_trunc(arrayChecked, "$(ENV["APP_PATH"])/public/plots/$(basename(csv_path))")
      return json(Dict("filename" => basename(files_dict["filename"])))
    end
end
