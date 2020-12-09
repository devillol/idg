using Genie.Router
using MainController, LemiController, ElectrovertController, SpectrController

route("/", MainController.main)
route("/", MainController.frame, method="POST")

route("/lemi", LemiController.main)
route("/lemi", LemiController.frame, method="POST")
route("/lemi/download_trunc", LemiController.trunc, method="POST")

route("/electrovert", ElectrovertController.main)
route("/electrovert", ElectrovertController.frame, method="POST")
route("/electrovert/download_trunc", ElectrovertController.trunc, method="POST")

route("/spectr", SpectrController.main)
route("/spectr", SpectrController.frame, method="POST")