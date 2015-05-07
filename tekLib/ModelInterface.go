package tekLib

import (
	// "bufio"
	// "github.com/astaxie/beego/config"
	// "encoding/json"
	// "errors"
	"fmt"
	// "github.com/codegangsta/cli"
	// "github.com/tealeg/xlsx"
	// "os"
	// "strconv"
	// "strings"
	// "time"
)

// type ProductName string
type OrderInfo struct {
	ID                               string
	CurrentItemCount, TotalItemCount int
}

func NewOrderInfo(order *Order) *OrderInfo {
	current, total := order.GetItemCount()
	return &OrderInfo{
		ID:               order.ID,
		CurrentItemCount: current,
		TotalItemCount:   total,
	}
}

type OrderInfoList []*OrderInfo

func NewOrderInfoList(orderList OrderList) OrderInfoList {
	list := OrderInfoList{}
	for _, order := range orderList {
		list = append(list, NewOrderInfo(order))
	}
	return list
}

//订单结构
type Order struct {
	ID    string
	Items OrderItemList
}

func NewOrder(id string, items OrderItemList) *Order {
	if items == nil {
		items = OrderItemList{}
	}
	return &Order{
		ID:    id,
		Items: items,
	}
}
func (this *Order) Need(productName string) bool {
	for _, item := range this.Items {
		if item.ProductName == productName {
			item.PlusOne()
			return true
		}
	}
	return false
}
func (this *Order) GetItemCount() (int, int) {
	current, total := 0, 0
	for _, item := range this.Items {
		current += item.CountCurrent
		total += item.CountNeed
	}
	return current, total
}
func (this *Order) Print() {
	DebugTrace(fmt.Sprintf("订单编号：%s 含有商品种类%d", this.ID, len(this.Items)) + GetFileLocation())
	this.Items.Print()
}
func (this *Order) AddOrderItem(item *OrderItem) {
	this.Items = this.Items.Add(item)
}
func (this *Order) Completed() bool {
	for _, _item := range this.Items {
		if _item.Satisfied() == false {
			return false
		}
	}
	return true
}

type OrderList []*Order

func (this OrderList) Find(id string) *Order {
	for _, order := range this {
		if order.ID == id {
			return order
		}
	}
	return nil
}
func (this OrderList) Need(productName string) *Order {
	for _, order := range this {
		if order.Need(productName) == true {
			return order
		}
	}
	return nil
}
func (this OrderList) Uncompleted() OrderList {
	list := OrderList{}
	for _, order := range this {
		if current, totalNeed := order.GetItemCount(); current == totalNeed {
			list = append(list, order)
		}
	}
	return list
}
func (this OrderList) Remove(id string) OrderList {
	for i, _order := range this {
		if _order.ID == id {
			return append(this[0:i], this[i+1:]...)
		}
	}
	return this
}
func (this OrderList) Add(orders ...*Order) OrderList {
	tempList := this
	for _, order := range orders {
		if tempList.Find(order.ID) == nil {
			tempList = append(tempList, order)
		}
	}
	return tempList
}

//之前存在的订单不会重复添加
func (this OrderList) AddRange(orders OrderList) OrderList {
	tempList := this
	for _, order := range orders {
		if tempList.Find(order.ID) == nil {
			tempList = append(tempList, order)
		}
	}
	return tempList
}
func (this OrderList) Print() {
	DebugTrace(G_DebugLine)
	for _, order := range this {
		order.Print()
	}
	DebugTrace(G_DebugLine)
}

type OrderItem struct {
	ProductName, OrderID    string
	CountNeed, CountCurrent int
}

func NewOrderItem(productID string, count int, orderID string) *OrderItem {
	return &OrderItem{
		ProductName:  productID,
		CountNeed:    count,
		CountCurrent: 0,
		OrderID:      orderID,
	}
}
func (this *OrderItem) Satisfied() bool {
	return this.CountNeed == this.CountCurrent
}
func (this *OrderItem) Print() {
	DebugTrace(fmt.Sprintf("		商品名称：%s  需求量：%d", this.ProductName, this.CountNeed) + GetFileLocation())
}
func (this *OrderItem) PlusOne() {
	// this.CountCurrent += 1
	this.PlusOrderedItem(1)
}

//将同类的需求数目合并
func (this *OrderItem) PlusOrderedItem(count int) {
	this.CountNeed = this.CountNeed + count
}

type OrderItemList []*OrderItem

func (this OrderItemList) Print() {
	for _, item := range this {
		item.Print()
	}
}
func (this OrderItemList) Find(productID, orderID string) *OrderItem {
	for _, _item := range this {
		if _item.ProductName == productID && _item.OrderID == orderID {
			return _item
		}
	}
	return nil
}
func (this OrderItemList) Add(item *OrderItem) OrderItemList {
	if _item := this.Find(item.ProductName, item.OrderID); _item != nil {
		_item.PlusOrderedItem(item.CountNeed)
	} else {
		return append(this, NewOrderItem(item.ProductName, item.CountNeed, item.OrderID))
	}
	return this
}

//商品信息：名称和条码
type ProductInfo struct {
	Name    string
	Barcode string
}
type ProductInfoList []*ProductInfo

func (this ProductInfoList) Find(code string) *ProductInfo {
	for _, pi := range this {
		if pi.Barcode == code {
			return pi
		}
	}
	return nil
}

type OrderAndExpressmanMap struct {
	OrderID      string
	ExpressmanID string
}

func NewOrderToExpressman(orderID, man string) *OrderAndExpressmanMap {
	return &OrderAndExpressmanMap{
		OrderID:      orderID,
		ExpressmanID: man,
	}
}

type OrderAndExpressmanMapList []*OrderAndExpressmanMap

func (this OrderAndExpressmanMapList) Find(orderID string) *OrderAndExpressmanMap {
	for _, oem := range this {
		if oem.OrderID == orderID {
			return oem
		}
	}
	return nil
}
func (this OrderAndExpressmanMapList) Add(oem *OrderAndExpressmanMap) OrderAndExpressmanMapList {
	return append(this, oem)
}

/*
//从文件中导入订单信息和部分商品编码信息
func UploadOrderInfoFromFile(excelFileName string, fileType string) error {
	excelFileName = "temp/" + excelFileName
	var err error
	var xlFile *xlsx.File
	if xlFile, err = xlsx.OpenFile(excelFileName); err != nil {
		DebugMust(err.Error())
		return err
	}
	//检查格式
	fmt.Println(fmt.Sprintf("文件中共有 %d 个 sheet", len(xlFile.Sheets)))

	if len(xlFile.Sheets) <= 0 {
		return errors.New("文件中没有数据")
	}
	var ordersTemp OrderList
	firstSheet := xlFile.Sheets[0]
	switch fileType {
	case "1": //从配送单中提取订单信息
		DebugInfo("从配送单中提取订单信息" + GetFileLocation())
		ordersTemp, err = extractOrderInfoFromDistributionDetail(firstSheet)
	case "2": //从订单详细情况文件中提取订单信息
		DebugInfo("从订单中提取订单信息" + GetFileLocation())
		ordersTemp, err = extractOrderInfoFromOrderDetail(firstSheet)
	}
	if err == nil || err == ThereIsFiltedOrdersError {
		addedCount := len(Orders)
		Orders = Orders.AddRange(ordersTemp)
		addedCount = len(Orders) - addedCount

		Orders.Print()
		DebugInfo(fmt.Sprintf("成功添加了 %d 个订单", addedCount) + GetFileLocation())
		if err == ThereIsFiltedOrdersError {
			DebugInfo(fmt.Sprintf("还有 %d 个不明确的订单项需要处理", len(OrderItemsTemp)) + GetFileLocation())
		}
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

	DebugInfo("导入订单信息列表:")
	ordersTemp := OrderList{}
	itemsFilted := OrderItemList{}
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

		DebugInfo(_orderID + "  " + _content + GetFileLocation())
		_orderID = G_OrderPrefix + _orderID //易果系统会自动添加 前缀 作为识别码
		if len(_content) <= 0 {
			continue
		}
		items, _itemsFilted := splitOrderItems(_content, _orderID)
		itemsFilted = itemsFilted.AddRange(_itemsFilted)
		if len(items) <= 0 {
			DebugSys("订单里没有订购信息，出现解析异常")
			continue
		}
		if orderTemp := ordersTemp.Find(_orderID); orderTemp == nil {
			ordersTemp = ordersTemp.Add(NewOrder(_orderID, "", "", items))
		} else {
			// orderTemp.AddOrderItems(items)
			//每行只有一个订单，如果之前已经有该订单，说明是订单重复导入
		}
	}
	if len(itemsFilted) > 0 {
		OrderItemsTemp = OrderItemsTemp.AddRange(itemsFilted)
		return ordersTemp, ThereIsFiltedOrdersError
	} else {
		return ordersTemp, nil
	}
}

//将配送单里面的内容拆分成订单
func splitOrderItems(content, orderID string) (OrderItemList, OrderItemList) {
	orderItemsFilted := OrderItemList{}
	list := OrderItemList{}
	if strings.Contains(content, "自由拼：") == true {
		content = strings.Replace(content, "自由拼：", "", -1)
		content = strings.Replace(content, "，", ",", -1)
		nameWithCountList := strings.Split(content, ",")
		for _, combined := range nameWithCountList {
			countFlagIndex := strings.Index(combined, "数量：")
			productName := strings.Trim(combined[:countFlagIndex], " ")
			strCount := strings.Trim(combined[countFlagIndex+9:], " ")
			if count, err := strconv.ParseFloat(strCount, 32); err != nil {
				DebugSys(fmt.Sprintf("解析订单数量时出错：%s %s  %s", err.Error(), productName, strCount) + GetFileLocation())
				continue
			} else {
				DebugInfo(fmt.Sprintf("解析出订单项：名称=> %s 数量 => %d", productName, int(count)))
				newOrderItem := NewOrderItem(productName, int(count), orderID)
				status := GetProductNameStatus(productName)
				switch status {
				case Const_ProductName_IN:
					list = append(list, newOrderItem)

				case Const_ProductName_NOT_IN:
					DebugInfo(productName + " 已经被过滤" + GetFileLocation())

				case Const_ProductName_NOT_SURE:
					DebugInfo(productName + " 无法确定，添加到待确定列表中" + GetFileLocation())
					orderItemsFilted = append(orderItemsFilted, newOrderItem)
				}

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

	DebugInfo(rowHeader)
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

	DebugInfo("导入订单信息列表:")
	orderItemsFilted := OrderItemList{}
	ordersTemp := OrderList{}
	maxCol := 6
	rows = rows[1:]
	for _, row := range rows {

		str := ""
		for i := 0; i < maxCol; i++ {
			str = str + "    " + row.Cells[i].String()
		}
		DebugInfo(str + GetFileLocation())

		_orderID := strings.Trim(row.Cells[0].Value, " ")
		_deliver := strings.Trim(row.Cells[1].Value, " ")
		_delivingTime := strings.Trim(row.Cells[2].String(), " ")
		_productBarcode := strings.Trim(row.Cells[3].Value, " ")
		_countStr := strings.Trim(row.Cells[4].Value, " ")
		_productName := strings.Trim(row.Cells[5].Value, " ")

		// if len(_productBarcode) <= 0 { //目前产品ID为空表示该产品不属于冻库
		// 	continue
		// }
		_orderID = G_OrderPrefix + _orderID //易果系统会自动添加 前缀 作为识别码
		_count, err := strconv.Atoi(_countStr)
		if err != nil {
			DebugMust(fmt.Sprintf("转换订单（%s）中商品（%s）数量时出错：%s", _orderID, _productBarcode, err.Error()) + GetFileLocation())
			continue
		}
		newOrderItem := NewOrderItem(_productName, _count, _orderID)

		status := GetProductNameStatus(_productName)
		switch status {
		case Const_ProductName_IN:
			if orderTemp := ordersTemp.Find(_orderID); orderTemp == nil {
				ordersTemp = ordersTemp.Add(NewOrder(_orderID, _deliver, _delivingTime, OrderItemList{newOrderItem}))
			} else {
				orderTemp.AddOrderItem(newOrderItem)
			}
		case Const_ProductName_NOT_IN:
			DebugInfo(_productName + " 已经被过滤" + GetFileLocation())

		case Const_ProductName_NOT_SURE:
			DebugInfo(_productName + " 无法确定，添加到待确定列表中" + GetFileLocation())
			orderItemsFilted = append(orderItemsFilted, newOrderItem)
		}
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
	if len(orderItemsFilted) > 0 {
		OrderItemsTemp = OrderItemsTemp.AddRange(orderItemsFilted)
		return ordersTemp, ThereIsFiltedOrdersError
	} else {
		return ordersTemp, nil
	}
}

func UpdateProductInfoFromFile(excelFileName string) error {
	excelFileName = "temp/" + excelFileName
	xlFile, err := xlsx.OpenFile(excelFileName)
	if err != nil {
		DebugMust(err.Error())
		return err
	}
	//检查格式
	fmt.Println(fmt.Sprintf("文件中共有 %d 个 sheet", len(xlFile.Sheets)))
	if len(xlFile.Sheets) <= 0 {
		return errors.New("文件格式错误")
	}

	if len(xlFile.Sheets) > 0 {
		firstSheet := xlFile.Sheets[0]
		if len(firstSheet.Rows) <= 0 || len(firstSheet.Cols) < 3 {
			return errors.New("文件格式错误 1")

		}
		rows := firstSheet.Rows
		if "商品编码" != strings.Trim(rows[0].Cells[2].Value, " ") ||
			"商品名称" != strings.Trim(rows[0].Cells[1].Value, " ") {
			DebugInfo(strings.Trim(rows[0].Cells[2].Value, " ") + "  " + strings.Trim(rows[0].Cells[1].Value, " "))
			return errors.New("文件格式错误 2")
		}
		DebugInfo("导入商品信息列表:")
		maxCol := 2
		addedCount := 0
		for j, row := range rows {
			if j <= 0 {
				continue
			}
			str := ""
			for i := 0; i < maxCol; i++ {
				str = str + "    " + row.Cells[i].String()
			}
			productID := strings.Trim(row.Cells[2].String(), " ")
			if len(productID) <= 0 {
				continue
			}

			if err := AddProduct(productID, strings.Trim(row.Cells[1].String(), " ")); err == nil {
				// fmt.Println(str)
				addedCount++
			} else {
				DebugInfo(err.Error() + GetFileLocation())
			}
		}
		DebugInfo(fmt.Sprintf("成功添加了 %d 个产品信息", addedCount) + GetFileLocation())
	}
	return nil
}
*/
