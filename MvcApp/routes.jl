using Genie.Router
using MainController, LemiController

route("/", MainController.main)
route("/", MainController.frame, method="POST")

route("/lemi", LemiController.main)
route("/lemi", LemiController.frame, method="POST")
route("/lemi/download_trunc", LemiController.trunc, method="POST")