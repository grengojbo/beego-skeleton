package main

import (
	_ "github.com/grengojbo/beego-skeleton/docs"
	_ "github.com/grengojbo/beego-skeleton/routers"

	"github.com/astaxie/beego"
)

func main() {
	beego.Info("AppPath:", beego.AppPath)
	if beego.RunMode == "dev" {
		beego.DirectoryIndex = true
		beego.StaticDir["/swagger"] = "swagger"
	}
	beego.Run()
}
