package main

import (
	"fmt"

	_ "github.com/grengojbo/beego-skeleton/docs"
	_ "github.com/grengojbo/beego-skeleton/routers"
	// "github.com/beego/i18n"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	_ "github.com/go-sql-driver/mysql"
)

func init() {
	var c map[string]string
	beego.Debug("main initialize...")
	orm.RegisterDriver("mysql", orm.DR_MySQL)
	// param 4 (optional):  set maximum idle connections
	// param 4 (optional):  set maximum connections (go >= 1.2)
	maxIdle := 30
	maxConn := 30
	if beego.RunMode == "dev" {
		c, _ = beego.AppConfig.GetSection("dev")
	} else if beego.RunMode == "test" {
		c, _ = beego.AppConfig.GetSection("test")
	} else {
		c, _ = beego.AppConfig.GetSection("prod")
	}
	sqlMysqlConnect := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8", c["mysql_user"], c["mysql_pass"], c["mysql_host"], c["mysql_port"], c["mysql_db"])
	orm.RegisterDataBase("default", "mysql", sqlMysqlConnect, maxIdle, maxConn)
}

func main() {
	beego.Info("AppPath:", beego.AppPath)
	beego.SetStaticPath("/static", "public/static")
	beego.SetStaticPath("/media", "public/media")
	if beego.RunMode == "dev" {
		beego.Info("Develment mode enabled")
		beego.DirectoryIndex = true
		beego.StaticDir["/swagger"] = "swagger"
	} else {
		beego.Info("Product mode enabled")
	}

	beego.Info(beego.AppName)
	// beego.AddFuncMap("i18n", i18n.Tr)

	beego.Run()
}
