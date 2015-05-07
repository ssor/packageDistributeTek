package tekLib

import (
	"bufio"
	"github.com/astaxie/beego/config"
	// "encoding/json"
	// "errors"
	"fmt"
	"github.com/codegangsta/cli"
	// "github.com/tealeg/xlsx"
	"os"
	"strconv"
	"strings"
	"time"
)

const (
	DEFAULT_LOCATION_COUNT = 8
	DEFAULT_SHELF_COUNT    = 4
)

var (
	// G_shelfCount    int                     = DEFAULT_SHELF_COUNT //拣选墙数目
	// G_locationCount int                     = DEFAULT_LOCATION_COUNT        //每个拣选墙的货位数
	G_OrderAndExpressmanMaps OrderAndExpressmanMapList = OrderAndExpressmanMapList{}
	G_Products               ProductInfoList           = ProductInfoList{}
	G_chanPickup             chan *PickupRequestInfo   = make(chan *PickupRequestInfo) //拣选的请求信息
	iniconf                  config.ConfigContainer    = nil
	cliApp                   *cli.App                  = nil //交互线程
	G_orders                 OrderList                 = OrderList{}
	// ProductNames    ProductNameList         = ProductNameList{} //数据库中支持的商品名称
	// ProductNameFilterKewwords []string                = []string{}
	// G_OrderPrefix             string                  = ""                //订单的前缀，有的订单以 800 开始
)

func init() {
	// return
	// if err := InitDB(); err != nil {
	// 	DebugMust("数据库初始化失败：" + err.Error() + GetFileLocation())
	// }
	// initConfig()
	// if tempList, err := GetAllProductsFromDB(); err == nil {
	// 	Products = tempList
	// 	DebugInfo("从数据库读取产品信息成功")
	// } else {
	// 	DebugMust("读取产品信息失败")
	// }
	// if tempList, err := GetAllProductNameFromDB(); err == nil {
	// 	ProductNames = tempList
	// 	DebugInfo(fmt.Sprintf("读取支持的产品名称信息成功, 共 %d 个", len(ProductNames)))
	// } else {
	// 	DebugMust("读取产品名称信息失败")
	// }

	// Positions = NewPositionList(G_locationCount)
	go initBusiness()
	// go initCli()
}
func GetUncompltedOrdersCount() int {
	return len(G_orders.Uncompleted())

}
func PickUp(id string) *PickupInfo {
	DebugInfo("开始拣选 ID = " + id + GetFileLocation())
	chanCallback := make(chan *PickupInfo)
	request := &PickupRequestInfo{chanCallback: chanCallback, ID: id}
	G_chanPickup <- request
	returnTicker := time.After(time.Second * 2)
	for {
		select {
		case info := <-chanCallback:
			return info
		case <-returnTicker:
			return NewPickupErrorInfo(其它错误, id, "操作超时")
		}
	}
}
func DoWithPickupEvents(request *PickupRequestInfo) {
	info := NewPickupErrorInfo(其它错误, request.ID, "发现不能识别的编码")
	defer func() {
		request.chanCallback <- info
	}()
	//传递进的条码有两种可能：订单的ID和商品的唯一码或者统一码
	//如果是订单的ID，根据订单和快递员的绑定信息返回快递员ID
	//如果是商品的唯一码，则要根据唯一码查找到商品名称，再将商品名称对应到订单上，最后查找到对应的快递员ID

	if orderTemp := G_orders.Find(request.ID); orderTemp != nil { //这是一个订单编号，直接查找配送员
		oem := G_OrderAndExpressmanMaps.Find(request.ID)
		if oem == nil {
			info = NewPickupErrorInfo(没有订单与配送员的绑定信息, request.ID, "订单没有指定配送员")
			return
		}
		info = NewPickupInfo(成功查找, oem.ExpressmanID, request.ID)
		return
	} else if product := G_Products.Find(request.ID); product != nil { //这是一个产品单号，需要在分配货位的订单中查找需要的订单
		DebugTrace(fmt.Sprintf("接收到产品编码 %s 名称 %s", request.ID, product.Name) + GetFileLocation())
		if orderTemp := G_orders.Need(product.Name); orderTemp == nil { //没有订单里需要该商品
			info = NewPickupErrorInfo(没有订单需要该商品, request.ID, "没有订单需要商品"+product.Name)
			return
		} else { //查找到订单了，然后根据订单查找到人就可以了
			oem := G_OrderAndExpressmanMaps.Find(orderTemp.ID)
			if oem == nil {
				info = NewPickupErrorInfo(没有订单与配送员的绑定信息, request.ID, fmt.Sprintf("商品 %s 在订单%s中，但没有指定配送员", product.Name, orderTemp.ID))
				return
			}
			info = NewPickupInfo(成功查找, oem.ExpressmanID, request.ID)
		}
	} else {
		DebugInfo(fmt.Sprintf("发现不能识别的编码 %s", request.ID) + GetFileLocation())
	}
}
func initBusiness() {
	for {
		select {
		case request := <-G_chanPickup:
			DoWithPickupEvents(request)
			// case request := <-G_chanMergeOrder:
			// 	DoMergeOrderEvents(request)
		}
	}
}

func initConfig() {
	var err error
	iniconf, err = config.NewConfig("ini", "conf/app.conf")
	if err != nil {
		DebugMust(err.Error() + GetFileLocation())
	} else {

		// G_OrderPrefix = iniconf.String("orderPrefix")
		// if len(G_OrderPrefix) > 0 {
		// 	DebugInfo(fmt.Sprintf("设置订单的前缀为 %s", G_OrderPrefix) + GetFileLocation())
		// } else {
		// 	DebugInfo(fmt.Sprintf("订单的前缀为空") + GetFileLocation())

		// }

		//过滤产品关键字
		// filterKeywords := iniconf.Strings("filterKeywords")
		// if len(filterKeywords) > 0 {
		// 	ProductNameFilterKewwords = append(ProductNameFilterKewwords, filterKeywords...)
		// 	DebugInfo(fmt.Sprintf("现有 %d 个过滤关键字", len(ProductNameFilterKewwords)) + GetFileLocation())
		// 	DebugInfo("过滤产品的关键字如下：" + GetFileLocation())
		// 	for _, keyword := range filterKeywords {

		// 		DebugInfo(keyword + GetFileLocation())
		// 	}
		// } else {
		// 	DebugInfo("没有检测到过滤产品的关键字" + GetFileLocation())
		// }
		// if err := iniconf.Set("locationCount", "23"); err != nil {
		// 	DebugMust(err.Error() + GetFileLocation())
		// }
		// if err := iniconf.SaveConfigFile("conf/app.conf"); err != nil {
		// 	DebugMust(err.Error() + GetFileLocation())
		// }
	}

}
func initCli() {
	cliApp := cli.NewApp()
	cliApp.Name = "config"
	cliApp.Usage = "设置系统运行参数"
	cliApp.Version = "1.0.1"
	cliApp.Email = "ssor@qq.com"
	cliApp.Commands = []cli.Command{
		{
			Name:        "log",
			ShortName:   "l",
			Usage:       "是否打印log，true为打开，false为关闭",
			Description: "当log太多，而需要与系统交互时可以关闭log的打印",
			Action: func(c *cli.Context) {
				// fmt.Println(fmt.Sprintf("%#v", c.Command))
				// fmt.Println("-----------------------------")
				value := strings.ToLower(c.Args().First())
				if value == "true" {
					fmt.Println("打开log打印")
					G_printLog = true
				} else if value == "false" {
					fmt.Println("关闭log打印")
					G_printLog = false
				} else {
					fmt.Println("参数错误")
				}
			},
		}, {
			Name:        "loglevel",
			ShortName:   "ll",
			Usage:       "设置打印log级别，数字越高，log打印越精细，默认值为3",
			Description: "当需要调试时，可以设置高级别打印",
			Action: func(c *cli.Context) {
				value := strings.ToLower(c.Args().First())
				if level, err := strconv.Atoi(value); err != nil {
					fmt.Println("参数错误")
				} else {
					DebugLevel = level
					fmt.Println("设置log打印级别为" + value)
				}
			},
		},
	}
	go func() {
		reader := bufio.NewReader(os.Stdin)
		for {
			fmt.Println("等待输入。。。")

			data, _, _ := reader.ReadLine()
			command := string(data)
			cliApp.Run(strings.Split(command, " "))
		}
	}()
	// app.Run(os.Args)
}
