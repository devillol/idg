using Genie.Configuration, Logging

const config = Settings(
  server_port                     = 8000,
  server_host                     = "127.0.0.1",
  log_level                       = Logging.Info,
  log_to_file                     = false,
  server_handle_static_files      = true
)

ENV["JULIA_REVISE"] = "auto"

ENV["SOURCE_DATA_PATH"] = "/Users/ruabsg2/IdeaProjects/idg_plots/DATA"
const APP_PATH = abspath(normpath(joinpath(@__DIR__, "..", "..")))
ENV["APP_PATH"] = APP_PATH