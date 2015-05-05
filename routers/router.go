package routers

import (
	"github.com/astaxie/beego"
	"packageDistributeTek/controllers"
)

func init() {
	//自动升级需要支持的接口
	beego.Router("/TestAlive", &controllers.MainController{}, "get:TestAlive")
	beego.Router("/Update", &controllers.MainController{}, "get:Update")

	//
	beego.Router("/NewUpdate", &controllers.MainController{}, "get:NewUpdate") //
	beego.Router("/UpdateNow", &controllers.MainController{}, "get:UpdateNow") //
	beego.Router("/", &controllers.MainController{}, "get:Index")

	beego.Router("/OrderListIndex", &controllers.MainController{}, "get:OrderListIndex")
	beego.Router("/OrderInfoList", &controllers.MainController{}, "get:OrderInfoList")

}
