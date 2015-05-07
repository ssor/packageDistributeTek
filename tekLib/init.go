package tekLib

import (
	"bufio"
	"github.com/astaxie/beego/config"
	// "encoding/json"
	"errors"
	"fmt"
	"github.com/codegangsta/cli"
	"github.com/tealeg/xlsx"
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
	G_OrderPrefix            string                    = "" //订单的前缀，有的订单以 800 开始
	// ProductNames    ProductNameList         = ProductNameList{} //数据库中支持的商品名称
	// ProductNameFilterKewwords []string                = []string{}
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
func ClearCompletedOrders() error {
	list := OrderList{}
	for _, order := range G_orders {
		if order.Completed() == false {
			list = append(list, order)
		}
	}
	G_orders = list
	return nil
}
func UploadOrderToExpressmanInfo(sheet *xlsx.Sheet) error {
	rows := sheet.Rows

	//****************************************************************************************
	// 数据从行4开始，包含内容的列 1 订单流水号 4 配送员
	//****************************************************************************************
	testColName := func(colName []string, colIndex []int, row *xlsx.Row) error {
		length := len(colName)
		for i := 0; i < length; i++ {
			cellValue := strings.Trim(row.Cells[colIndex[i]].Value, " ")
			if cellValue != colName[i] {
				return errors.New(fmt.Sprintf("文件格式错误, 第 %d 列应该是 %s，现在是 %s", colIndex[i]+1, colName[i], cellValue))
			}
		}
		return nil
	}
	if err := testColName([]string{"订单流水号", "配送员"},
		[]int{0, 3},
		rows[0]); err != nil {
		return err
	}
	DebugInfo("导入订单分配到配送员信息:" + GetFileLocation())
	DebugTrace(G_DebugLine)
	// ordersTemp := OrderList{}
	count := 0
	rows = rows[1:]
	for i, row := range rows {

		_orderID := strings.Trim(row.Cells[0].Value, " ") //流水号
		_expressman := strings.Trim(row.Cells[3].Value, " ")

		DebugTrace(fmt.Sprintf("%d: %s -> %s", i+1, _orderID, _expressman) + GetFileLocation())
		_orderID = G_OrderPrefix + _orderID //易果系统会自动添加 前缀 作为识别码
		if len(_expressman) <= 0 {
			DebugSys(fmt.Sprintf("订单 %s 没有指定配送员", _orderID) + GetFileLocation())
			continue
		}
		G_OrderAndExpressmanMaps = G_OrderAndExpressmanMaps.Add(NewOrderToExpressman(_orderID, _expressman))
		count += 1
	}
	DebugTrace(G_DebugLine)

	DebugInfo(fmt.Sprintf("共导入了 %d 个分配信息", count))
	return nil
}
func UploadFromFile(excelFileName string, fileType string) error {
	excelFileName = "temp/" + excelFileName
	var err error
	var xlFile *xlsx.File
	if xlFile, err = xlsx.OpenFile(excelFileName); err != nil {
		DebugMust(err.Error())
		return err
	}
	//检查格式
	// fmt.Println(fmt.Sprintf("文件中共有 %d 个 sheet", len(xlFile.Sheets)))

	if len(xlFile.Sheets) <= 0 {
		return errors.New("文件中没有数据")
	}
	// var ordersTemp OrderList
	firstSheet := xlFile.Sheets[0]
	switch fileType {
	case "1", "2":
		return UploadOrderInfoFromFile(firstSheet, fileType)
	case "3":
		return UploadOrderToExpressmanInfo(firstSheet)
	}
	return nil
}

//从文件中导入订单信息和部分商品编码信息
func UploadOrderInfoFromFile(sheet *xlsx.Sheet, fileType string) error {
	// func UploadOrderInfoFromFile(excelFileName string, fileType string) error {
	// excelFileName = "temp/" + excelFileName
	var err error
	// var xlFile *xlsx.File
	// if xlFile, err = xlsx.OpenFile(excelFileName); err != nil {
	// 	DebugMust(err.Error())
	// 	return err
	// }
	// //检查格式
	// // fmt.Println(fmt.Sprintf("文件中共有 %d 个 sheet", len(xlFile.Sheets)))

	// if len(xlFile.Sheets) <= 0 {
	// 	return errors.New("文件中没有数据")
	// }
	var ordersTemp OrderList
	// firstSheet := xlFile.Sheets[0]

	switch fileType {
	case "1": //从配送单中提取订单信息
		DebugInfo("从配送单中提取订单信息" + GetFileLocation())
		ordersTemp, err = extractOrderInfoFromDistributionDetail(sheet)
	case "2": //从订单详细情况文件中提取订单信息
		DebugInfo("从订单中提取订单信息" + GetFileLocation())
		ordersTemp, err = extractOrderInfoFromOrderDetail(sheet)
	}
	if err == nil {
		addedCount := len(G_orders)
		G_orders = G_orders.AddRange(ordersTemp)
		addedCount = len(G_orders) - addedCount

		G_orders.Print()
		DebugInfo(fmt.Sprintf("成功添加了 %d 个订单", addedCount) + GetFileLocation())

		return err
	} else {
		return err
	}

	// MergeOrders(ordersTemp)
	return nil
}

//从配送单中提取订单
func extractOrderInfoFromDistributionDetail(sheet *xlsx.Sheet) (OrderList, error) {
	firstSheet := sheet
	DebugTrace(fmt.Sprintf("文件最大列是 %d  最大行是 %d", firstSheet.MaxCol, firstSheet.MaxRow))
	if len(firstSheet.Rows) <= 5 || len(firstSheet.Cols) < 14 {
		return nil, errors.New("文件格式错误")
	}
	rows := firstSheet.Rows

	//****************************************************************************************
	// 数据从行4开始，包含内容的列 1 自由拼序号 4 流水号 5 司机 6 配送时间 7 内容  10 备注
	//****************************************************************************************
	testColName := func(colName []string, colIndex []int, row *xlsx.Row) error {
		length := len(colName)
		for i := 0; i < length; i++ {
			if strings.Trim(row.Cells[colIndex[i]].Value, " ") != colName[i] {
				return errors.New(fmt.Sprintf("文件格式错误, 第 %d 列应该是 %s", i+1, colName[i]))
			}
		}
		return nil
	}
	if err := testColName([]string{"自由拼序号", "流水号", "司机", "配送时间", "内容", "备注"},
		[]int{1, 4, 5, 6, 7, 10},
		rows[4]); err != nil {
		return nil, err
	}
	DebugInfo("导入订单信息列表:" + GetFileLocation())
	DebugTrace(G_DebugLine)
	ordersTemp := OrderList{}
	// itemsFilted := OrderItemList{}
	rows = rows[5:]
	for _, row := range rows {
		// DebugTrace(fmt.Sprintf("第 %d 行 含有 %d 列", i, len(row.Cells)) + GetFileLocation())
		if len(row.Cells) < 13 {
			continue
		}
		// str := ""
		// for i := 0; i < maxCol; i++ {
		// 	str = str + "    " + row.Cells[i].String()
		// }
		// DebugInfo(str + GetFileLocation())

		// _sequenceID := strings.Trim(row.Cells[1].Value, " ")//自由拼序号
		_orderID := strings.Trim(row.Cells[4].Value, " ") //流水号
		_content := strings.Trim(row.Cells[7].Value, " ")

		DebugTrace(_orderID + "  " + _content + GetFileLocation())
		_orderID = G_OrderPrefix + _orderID //易果系统会自动添加 前缀 作为识别码
		if len(_content) <= 0 {
			continue
		}
		items, _ := splitOrderItems(_content, _orderID)
		// itemsFilted = itemsFilted.AddRange(_itemsFilted)
		if len(items) <= 0 {
			// DebugSys("订单里没有订购信息，出现解析异常，原数据：" + _orderID + "  " + _content + GetFileLocation())
			continue
		}
		if orderTemp := ordersTemp.Find(_orderID); orderTemp == nil {
			ordersTemp = ordersTemp.Add(NewOrder(_orderID, items))
		} else {
			// orderTemp.AddOrderItems(items)
			//每行只有一个订单，如果之前已经有该订单，说明是订单重复导入
		}
	}
	DebugTrace(G_DebugLine)

	return ordersTemp, nil
}

//将配送单里面的内容拆分成订单
func splitOrderItems(content, orderID string) (OrderItemList, OrderItemList) {
	orderItemsFilted := OrderItemList{}
	list := OrderItemList{}
	if strings.Contains(content, "自由拼：") == true {
		content = strings.Replace(content, "自由拼：", "", -1)
		content = strings.Replace(content, "，", ",", -1)
		content = strings.Replace(content, "：", ":", -1)
		nameWithCountList := strings.Split(content, ",")
		for _, combined := range nameWithCountList {
			DebugTrace("需要解析的内容：" + combined + GetFileLocation())
			countFlagIndex := strings.Index(combined, "数量:")
			productName := strings.Trim(combined[:countFlagIndex], " ")
			strCount := strings.Trim(combined[countFlagIndex+7:], " ")
			if count, err := strconv.ParseFloat(strCount, 32); err != nil {
				DebugSys(fmt.Sprintf("解析订单数量时出错, 产品名称：（%s） 数量：（%s） 原因： %s", productName, strCount, err.Error()) + GetFileLocation())
				continue
			} else {
				DebugTrace(fmt.Sprintf("解析出订单项：名称=> %s 数量 => %d", productName, int(count)) + GetFileLocation())
				newOrderItem := NewOrderItem(productName, int(count), orderID)
				list = append(list, newOrderItem)
				// status := GetProductNameStatus(productName)
				// switch status {
				// case Const_ProductName_IN:
				// 	list = append(list, newOrderItem)

				// case Const_ProductName_NOT_IN:
				// 	DebugInfo(productName + " 已经被过滤" + GetFileLocation())

				// case Const_ProductName_NOT_SURE:
				// 	DebugInfo(productName + " 无法确定，添加到待确定列表中" + GetFileLocation())
				// 	orderItemsFilted = append(orderItemsFilted, newOrderItem)
				// }

				// if ProductShouldBeFiltered(productName) == true {
				// 	DebugInfo(productName + " 已经被过滤")
				// 	orderItemsFilted = append(orderItemsFilted, newOrderItem)
				// } else {
				// 	list = append(list, newOrderItem)
				// }
			}

		}
	}
	return list, orderItemsFilted
}

//从订单中提取订单
func extractOrderInfoFromOrderDetail(sheet *xlsx.Sheet) (OrderList, error) {
	firstSheet := sheet
	if len(firstSheet.Rows) <= 1 || len(firstSheet.Cols) < 6 {
		return nil, errors.New("文件中没有数据")
	}
	rows := firstSheet.Rows
	firstRow := rows[0]
	rowHeader := fmt.Sprintf("%s(%s)    %s(%s)    %s(%s)    %s(%s)    %s(%s)",
		firstRow.Cells[0].String(), firstRow.Cells[0].GetNumberFormat(),
		firstRow.Cells[1].String(), firstRow.Cells[1].GetNumberFormat(),
		firstRow.Cells[2].Value, firstRow.Cells[2].GetNumberFormat(),
		firstRow.Cells[3].String(), firstRow.Cells[3].GetNumberFormat(),
		firstRow.Cells[4].String(), firstRow.Cells[4].GetNumberFormat())

	testColName := func(colName []string, row *xlsx.Row) error {
		length := len(colName)
		for i := 0; i < length; i++ {
			if strings.Trim(row.Cells[i].Value, " ") != colName[i] {
				return errors.New(fmt.Sprintf("文件格式错误, 第 %d 列应该是 %s", i+1, colName[i]))
			}
		}
		return nil
	}
	if err := testColName([]string{"流水号", "司机", "配送时间", "商品编码", "数量", "商品名称"}, firstRow); err != nil {
		return nil, err
	}

	DebugInfo("导入订单信息列表:" + GetFileLocation())
	DebugTrace(G_DebugLine)
	DebugTrace(rowHeader)
	// orderItemsFilted := OrderItemList{}
	ordersTemp := OrderList{}
	maxCol := 6
	rows = rows[1:]
	for _, row := range rows {

		str := ""
		for i := 0; i < maxCol; i++ {
			str = str + "    " + row.Cells[i].String()
		}
		DebugTrace(str + GetFileLocation())

		_orderID := strings.Trim(row.Cells[0].Value, " ")
		// _deliver := strings.Trim(row.Cells[1].Value, " ")
		// _delivingTime := strings.Trim(row.Cells[2].String(), " ")
		_productBarcode := strings.Trim(row.Cells[3].Value, " ")
		_countStr := strings.Trim(row.Cells[4].Value, " ")
		_productName := strings.Trim(row.Cells[5].Value, " ")

		// if len(_productBarcode) <= 0 { //目前产品ID为空表示该产品不属于冻库
		// 	continue2
		// }
		_orderID = G_OrderPrefix + _orderID //易果系统会自动添加 前缀 作为识别码
		_count, err := strconv.Atoi(_countStr)
		if err != nil {
			DebugSys(fmt.Sprintf("转换订单（%s）中商品（%s）数量时出错：%s", _orderID, _productBarcode, err.Error()) + GetFileLocation())
			continue
		}
		newOrderItem := NewOrderItem(_productName, _count, _orderID)
		if orderTemp := ordersTemp.Find(_orderID); orderTemp == nil {
			ordersTemp = ordersTemp.Add(NewOrder(_orderID, OrderItemList{newOrderItem}))
		} else {
			orderTemp.AddOrderItem(newOrderItem)
		}

		// status := GetProductNameStatus(_productName)
		// switch status {
		// case Const_ProductName_IN:
		// 	if orderTemp := ordersTemp.Find(_orderID); orderTemp == nil {
		// 		ordersTemp = ordersTemp.Add(NewOrder(_orderID, _deliver, _delivingTime, OrderItemList{newOrderItem}))
		// 	} else {
		// 		orderTemp.AddOrderItem(newOrderItem)
		// 	}
		// case Const_ProductName_NOT_IN:
		// 	DebugInfo(_productName + " 已经被过滤" + GetFileLocation())

		// case Const_ProductName_NOT_SURE:
		// 	DebugInfo(_productName + " 无法确定，添加到待确定列表中" + GetFileLocation())
		// 	orderItemsFilted = append(orderItemsFilted, newOrderItem)
		// }
		// if ProductShouldBeFiltered(_productName) == true {
		// 	DebugInfo(_productName + " 已经被过滤" + GetFileLocation())
		// 	orderItemsFilted = append(orderItemsFilted, newOrderItem)
		// } else {
		// 	if orderTemp := ordersTemp.Find(_orderID); orderTemp == nil {
		// 		ordersTemp = ordersTemp.Add(NewOrder(_orderID, _deliver, _delivingTime, OrderItemList{newOrderItem}))
		// 	} else {
		// 		orderTemp.AddOrderItem(newOrderItem)
		// 	}
		// }
	}
	DebugTrace(G_DebugLine)

	return ordersTemp, nil
}
func RemoveOrder(orderID string) error {
	if o := G_orders.Find(orderID); o == nil {
		return errors.New("没有找到要删除的订单")
	} else {
		G_orders = G_orders.Remove(orderID)
		return nil
	}
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
