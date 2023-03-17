package main

import (
	"io/ioutil"
	"log"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()
	r.StaticFile("/login", "../public/login.html")
	r.StaticFile("/register", "../public/register.html")
	r.Static("/public/css", "../public/css")
	r.Static("/public/js", "../public/js")
	r.Static("/public/imgs", "./public/imgs")

	r.GET("/", func(ctx *gin.Context) {
		fsinfo, e := ioutil.ReadDir("/dist/")
		if e != nil {
			log.Fatal("read dir failed")
		}
		fsnames := make(map[int]string, len(fsinfo))
		for k, v := range fsinfo {
			fsnames[k] = v.Name()
		}
		ctx.JSON(200, fsnames)
	})

	r.POST("/auth", func(ctx *gin.Context) {
		user, b := ctx.GetPostForm("user")
		if !b {
			ctx.JSON(502, nil)
		}
		passwd, b := ctx.GetPostForm("passwd")
		if !b {
			ctx.JSON(502, nil)
		}
		ctx.JSON(200, gin.H{
			"user":   user,
			"passwd": passwd,
		})
		// 验证密码
		// 返回session_id
		// 跳转到访问页面
	})

	// 分层设计
	// 数据库层，数据库接口层

	r.Run(":8088")
}
