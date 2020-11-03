module MainController
  using Genie.Renderer.Html, Genie.Renderer.Json, CreatePlots, Genie.Requests, Statistics
  function main()
    html(:main, :main, frame="", layout=:app)
  end
  function frame()
    system = postpayload(:system, "electrovert")
    date_from = postpayload(:date_from, "2019-12-22")
    date_to = postpayload(:date_to, "2019-12-22")
    gr_min = parse(Int, postpayload(:gr_min, 10))
    fun = (postpayload(:function, "mean") == "mean") ? mean : median
    plot_fun = if system == "electrovert"
      CreatePlots.create_electrovert
    elseif system == "lemi018"
      CreatePlots.create_lemi
    elseif system == "spectr"
      CreatePlots.create_spectr
    end
    file = basename(plot_fun(date_from, date_to, gr_min, fun=fun, output_dir="***/MvcApp/public/plots"))
    json(Dict("file" => file))
  end
end
