module CreatePlots

using PlotlyJS
using CSV, Dates, Statistics, DataFrames, TimeSeries, MarketTechnicals

const SOURCE_DATA_PATH = ENV["SOURCE_DATA_PATH"]


function create_plot(system, date_from, date_to, output_dir;
    group_interval ::Union{Second,Minute, Hour} = Second(0))

    format = "Y-mm-dd HH:MM:SS.s"

    files = ["$SOURCE_DATA_PATH/$(uppercase(system))/$(date[1:4])/$(date[6:7])/$(lowercase(system)).$(date).csv"
    for date=map(string,Date(date_from):Day(1):Date(date_to))]
    files = filter(x -> isfile(x), files)
    if isempty(files); return "NO DATA" end

    if group_interval.value == 0
        step = length(files) * 60
        while mod(86400, step) > 0; step -= 1 end
    else
        step = Second(group_interval).value
    end

    if system == "electrovert"; step *= 100 end

    dfs = map(x -> CSV.read(x, dateformat=format)[begin:step:end, :], files)

    df = vcat(dfs...)

    plts = [Plot(scatter(; x=df["Time"], y=df[c], mode="lines", name=c),
                Layout(;title="$c for $date_from to $date_to",
                    xaxis=attr(title="Time", showgrid=true, zeroline=false),
                    yaxis=attr(title=c, zeroline=false)))
                    for c in names(df) if c != "Time"]

    plt = [plts...]
    csv_path = "$output_dir/$(lowercase(system))-$date_from-$date_to-$step.csv"
    CSV.write(csv_path, df, dateformat=format)

    plt_path = savefig(plt, "$output_dir/$(lowercase(system))-$date_from-$date_to.html")

    Dict("csv_path" => csv_path, "plt_path" => plt_path)
end
function sma_plot(csv_path, html_path; n=10)
    format = "Y-mm-dd HH:MM:SS.s"
    df = CSV.read(csv_path, dateformat=format)
    df = ifelse.(ismissing.(df), NaN, df)
    ta = TimeArray(df, timestamp=:Time)

    date_from = Date(timestamp(ta)[1])
    date_to = Date(timestamp(ta)[end])
    ta = sma(ta, n)

    plts = [Plot([scatter(; x=df["Time"], y=df[c], mode="lines", name="$c orig"),
                  scatter(; x=timestamp(ta), y=values(ta["$(c)_sma_$n"]), mode="lines", name="$c sma")  ],
                Layout(;title="$c for $date_from to $date_to",
                    xaxis=attr(title="Time", showgrid=true, zeroline=false),
                    yaxis=attr(title=c, zeroline=false)))
                    for c in names(df) if c != "Time"]

    plt = [plts...]
    csv_path = csv_path[begin:end-4] * "_sma_$n.csv"
    CSV.write(csv_path, df, dateformat=format)

    plt_path = savefig(plt, html_path)

    Dict("csv_path" => csv_path, "plt_path" => plt_path)
end

function create_spectr(date_from, date_to, gr_min=NaN; output_dir, fun=nothing)
    html_line = """
    <html>
        <head>
            <meta charset="utf-8">
        <title> SPECTR $date_from to $date_to </title>
        </head>
        <body>
    """

    for date=map(string, Date(date_from):Day(1):Date(date_to))
        src_path = "$SOURCE_DATA_PATH/SPECTR/$(date[1:4])/$(date[6:7])/"
        files = filter(x -> contains(x, string(date)), readdir(src_path))
        html_line  *= """
        <table>
            <caption><h2>Спектры за $date </h2></caption>
        """
        for f in files
            cp(joinpath(src_path, f), joinpath(output_dir, "imgs", basename(f)), force=true)
            html_line *= """<tr><td><image src="/plots/imgs/$f" width="1080px" height="720"></image></td><tr>"""
        end
        html_line *= """</table>"""
    end

    html_line *= """ 
    </body>
    </html>
    """
    path = joinpath(output_dir, "spectr-$date_from-$date_to.html")
    open(path, "w") do f
        write(f, html_line)
    end
    path
end

function download_trunc(arrayChecked, csv_path)
    format = "Y-mm-dd HH:MM:SS.s"
    df = select(CSV.read(csv_path, dateformat=format), :Time, arrayChecked)
    filename = csv_path[begin:end-4] * join(arrayChecked) * ".csv"
    CSV.write(filename, df, dateformat=format)
    Dict("filename" => filename)
end
end