package main

import (
	"github.com/astaxie/beego"
	// _ "pickupTek/pickupTekLib"
	_ "packageDistributeTek/routers"
)

func main() {
	beego.SetStaticPath("/images", "static/Image")
	beego.SetStaticPath("/bootstrap", "static/bootstrap")
	beego.SetStaticPath("/dataTable", "static/dataTable")
	beego.SetStaticPath("/desktopscreen", "static/desktopscreen")
	beego.SetStaticPath("/javascripts", "static/javascripts")
	beego.SetStaticPath("/stylesheets", "static/stylesheets")
	beego.SetStaticPath("/audio", "static/audio")
	beego.SetStaticPath("/files", "static/files")
	beego.SetStaticPath("/responsivenav", "static/responsive-nav")

	beego.Run()
}
