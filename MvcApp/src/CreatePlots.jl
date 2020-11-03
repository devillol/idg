module CreatePlots

using PlotlyJS
using CSV, Dates, Statistics, DataFrames


function skipError(x, fun, default=NaN)
    try 
        fun(x)
    catch
        default
    end
end

function create_grouped_df(df, gr_min, fun)
    format = DateFormat("Y-m-d H:M:S.s")
    trunc = DataFrames.select(df, :Time => ByRow(x -> floor(DateTime(x, format), Minute(gr_min)))=> :Time, :)    
    #rename(x -> replace(x, "_function"=> ""), aggregate(trunc, :Time, fun ∘ skipmissing))
    cols = [c for c in names(df) if c != "Time"]
    combine(groupby(trunc, :Time), cols .=> (x -> skipError(x, fun ∘ skipmissing)) .=> cols)
end

function create_electrovert(date_from, date_to, gr_min; output_dir, fun=median)
    files = ["***/idg/DATA/ELECTROVERT/$(date[1:4])/$(date[6:7])/electrovert.$(date).csv" for date=map(string,Date(date_from):Day(1):Date(date_to))]
    dfs = filter(x -> x isa DataFrame, map(x -> skipError(x, CSV.read), files))
    
    df = create_grouped_df(vcat(dfs...), gr_min, fun)
    sct1 = scatter(; x=df.Time, y=df.I1, mode="lines", name="I1")
    sct2 = scatter(; x=df.Time, y=df.I2, mode="lines", name="I2")
    layout = Layout(;title="$(string(fun)) I by every $gr_min minutes for $date_from to $date_to",
                     xaxis=attr(title="Time", showgrid=true, zeroline=false),
                     yaxis=attr(title="I", zeroline=false))
    plt = Plot([sct1, sct2], layout)
    savefig(plt, "$output_dir/electrovert-$date_from-$date_to-$(string(fun)).html")
end

function create_lemi(date_from, date_to, gr_min; output_dir, fun=mean)
    files = ["***/idg/DATA/LEMI018/$(date[1:4])/$(date[6:7])/lemi018.$(date).csv" for date=map(string,Date(date_from):Day(1):Date(date_to))]
    dfs = filter(x -> x isa DataFrame, map(x -> skipError(x, CSV.read), files))
    #df = CSV.read("/Users/ruabvmf/Documents/idg/DATA/LEMI018/$(date[1:4])/$(date[6:7])/lemi018.$(date).csv")
    format = "Y-m-d H:M:S.s"
    df = create_grouped_df(vcat(dfs...), gr_min, fun)
    layout1 = Layout(;title="B for $date_from to $date_to ($(string(fun)) by every $gr_min minutes)",
                    xaxis=attr(title="Time", showgrid=true, zeroline=false),
                    yaxis=attr(title="B", zeroline=false))
    plt1 = Plot([scatter(; x=df.Time, y=df.Bx, mode="lines", name="Bx"), 
            scatter(; x=df.Time, y=df.By, mode="lines", name="By"),
            scatter(; x=df.Time, y=df.Bz, mode="lines", name="Bz")], layout1
            )

    layout2 = Layout(;title="T for $date_from to $date_to ($(string(fun)) by every $gr_min minutes)",
            xaxis=attr(title="Time", showgrid=true, zeroline=false),
            yaxis=attr(title="T", zeroline=false))
    plt2 = Plot([scatter(; x=df.Time, y=df.Tin, mode="lines", name="Tin"), 
    scatter(; x=df.Time, y=df.Tout, mode="lines", name="Tout")], layout2
    )
    plt = [plt1, plt2]
    savefig(plt, "$output_dir/lemi018-$date_from-$date_to.html")
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
        src_path = "***/idg/DATA/SPECTR/$(date[1:4])/$(date[6:7])/"
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
end
