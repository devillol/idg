using Genie.Router
using MainController

route("/", MainController.main)
route("/", MainController.frame, method="POST")