package controllers

import (
	"fmt"
	"github.com/astaxie/beego"
	// "path"
	"net/http"
	"os"
	"packageDistributeTek/tekLib"
	// "strconv"
	"strings"
)

var G_updatePrepared = false

type Command struct {
	Code    int
	Message string
	Data    interface{}
}

func NewCommandData(code int, msg string, data interface{}) Command {
	cmd := newCommand(code, msg)
	cmd.Data = data
	return cmd
}
func newCommand(code int, msg string) Command {
	return Command{
		Code:    code,
		Message: msg,
	}
}

//----------------------------------------------------------------------

type MainController struct {
	beego.Controller
}

//测试服务器是否正常
func (this *MainController) Test() {
	this.Data["json"] = newCommand(0, "")
	this.ServeJson()
}
func (this *MainController) TestAlive() {
	this.Data["json"] = newCommand(0, "")
	this.ServeJson()
}
func (this *MainController) Update() {
	G_updatePrepared = true
	this.Data["json"] = newCommand(0, "")
	this.ServeJson()
}

//与人交互，现在可以通知升级助手进行升级了
func (this *MainController) UpdateNow() {
	resp, err := http.Get("http://localhost:" + "12306" + "/StartUpdate")
	if err != nil {
		tekLib.DebugSys(fmt.Sprintf("App无法接收升级提示: %s", err.Error()) + tekLib.GetFileLocation())
	}
	if resp.StatusCode != 200 {
		tekLib.DebugSys(fmt.Sprintf("App无法接收升级提示: %s", resp.Status) + tekLib.GetFileLocation())
	}
	this.Data["json"] = newCommand(0, "")
	this.ServeJson()
}

//查看是否有升级信息
func (this *MainController) NewUpdate() {
	if G_updatePrepared == true {
		this.Data["json"] = newCommand(0, "")
	} else {
		this.Data["json"] = newCommand(1, "")
	}
	this.ServeJson()
}

//----------------------------------------------------------------------
func (this *MainController) Index() {
	this.TplNames = "AppIndex.tpl"
}

// 订单列表页面
func (this *MainController) OrderListIndex() {
	this.TplNames = "OrderListIndex.tpl"
}

// 订单信息列表
func (this *MainController) OrderInfoList() {
	this.Data["json"] = tekLib.NewOrderInfoList(tekLib.G_orders)
	this.ServeJson()
}

// 商品信息管理页面
func (this *MainController) ProductManagementIndex() {
	this.TplNames = "ProductManagementIndex.tpl"
}

// 商品信息列表
func (this *MainController) ProductList() {
	this.Data["json"] = tekLib.G_Products
	this.ServeJson()
}

// 添加商品条码信息页面
func (this *MainController) AddProductIndex() {
	this.TplNames = "AddProductIndex.tpl"
}

// 订单分配信息列表页面
func (this *MainController) OrderToExpressmanManagementIndex() {
	this.TplNames = "OrderToExpressmanManagementIndex.tpl"
}

// 订单分配信息列表
func (this *MainController) OrderToExpressmanList() {
	this.Data["json"] = tekLib.G_OrderAndExpressmanMaps
	this.ServeJson()
}

// 添加订单分配信息
func (this *MainController) AddDistributeInfoIndex() {
	this.TplNames = "AddDistributeInfoIndex.tpl"
}

//拣选页面
func (this *MainController) PickUpIndex() {
	this.TplNames = "PickUpIndex.tpl"
}

// 提交拣选中扫描到的条码
func (this *MainController) SubmitPickupID() {
	info := tekLib.NewPickupErrorInfo(-1, "", "位置错误")
	defer func() {
		this.Data["json"] = info
		this.ServeJson()
	}()
	ID := this.GetString("ID")

	info = tekLib.PickUp(ID)
}

//获取未拣选完的订单的数量
func (this *MainController) GetUncompltedOrdersCount() {
	cmd := newCommand(1, "")
	defer func() {
		this.Data["json"] = cmd
		this.ServeJson()
	}()
	count := tekLib.GetUncompltedOrdersCount()
	cmd = NewCommandData(0, "", count)
}

func (this *MainController) AddOrderIndex() {
	this.TplNames = "AddOrderIndex.tpl"
}

func (this *MainController) RemoveOrder() {
	cmd := newCommand(0, "")
	defer func() {
		this.Data["json"] = cmd
		this.ServeJson()
	}()
	orderID := this.GetString("ID")
	if err := tekLib.RemoveOrder(orderID); err != nil {
		cmd = newCommand(1, err.Error())
		return
	}
}
func (this *MainController) ClearCompletedOrders() {
	cmd := newCommand(0, "")
	defer func() {
		this.Data["json"] = cmd
		this.ServeJson()
	}()
	if err := tekLib.ClearCompletedOrders(); err != nil {
		cmd = newCommand(1, err.Error())
		return
	}
}
func (this *MainController) UploadOrderInfo() {
	fileName := "" //上传的文件名，放置到暂存区
	cmd := newCommand(0, "")
	defer func() {
		if len(fileName) > 0 {
			//删除暂存文件
			if err := os.Remove("temp/" + fileName); err != nil {
				tekLib.DebugMust("删除暂存文件时出错：" + err.Error())
			} else {
				// tekLib.DebugSys("删除文件 " + fileName + " 成功" + tekLib.GetFileLocation())
			}
		}
		this.Data["json"] = cmd
		this.ServeJson()
	}()
	fileType := strings.Trim(this.GetString("type"), " ")
	if len(fileType) <= 0 {
		cmd = newCommand(1, "需要确定导入订单所使用的文件类型")
		return
	}
	fromFile := "fileName" + fileType
	_, header, err := this.GetFile(fromFile)
	if err != nil {
		tekLib.DebugSys(err.Error() + tekLib.GetFileLocation())
		cmd = newCommand(1, "数据导入失败")
		return
	}

	if header != nil {
		// tekLib.DebugInfo(header.Filename)
		// ext := path.Ext(header.Filename)
		fileName = header.Filename
		if err := this.SaveToFile(fromFile, "temp/"+fileName); err != nil {
			tekLib.DebugSys("保存文件出错：" + err.Error() + tekLib.GetFileLocation())
			cmd = newCommand(1, "上传文件出错")
			return
		} else {
			if err := tekLib.UploadOrderInfoFromFile(fileName, fileType); err != nil {
				tekLib.DebugSys(err.Error() + tekLib.GetFileLocation())
				cmd = newCommand(1, err.Error())
				return
			}
		}
	} else {
		tekLib.DebugSys("没有文件上传")
		cmd = newCommand(1, "上传文件出错")
		return
	}
}
func (this *MainController) OrderDetailIndex() {
	orderID := this.GetString("ID")
	if len(orderID) <= 0 {
		tekLib.DebugSys(fmt.Sprintf("无法获取参数 订单编号") + tekLib.GetFileLocation())
	}
	this.Data["orderID"] = orderID
	this.TplNames = "OrderDetailIndex.tpl"
}

// 订单详情
func (this *MainController) OrderDetail() {
	orderID := this.GetString("ID")
	orderTemp := tekLib.NewOrder(orderID, nil)
	defer func() {
		this.Data["json"] = orderTemp
		this.ServeJson()
	}()
	if len(orderID) <= 0 {
		return
	}
	if orderFinded := tekLib.G_orders.Find(orderID); orderFinded != nil {
		orderTemp = orderFinded
	}
}
