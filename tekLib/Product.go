package tekLib

import (
	// "errors"
	// "time"
	"fmt"
	"strings"
)

const (
	ProductType_Frozen     = 0
	ProductType_Non_Frozen = 1
)

type ProductName struct {
	Name        string
	ProductType int //所属品类，0，冻品 1，非冻品
}

func NewProductName(name string, productType int) *ProductName {
	return &ProductName{
		Name:        name,
		ProductType: productType,
	}
}

type ProductNameList []*ProductName

func (this ProductNameList) ToStringList() []string {
	list := []string{}
	for _, temp := range this {
		list = append(list, temp.Name)
	}
	return list
}
func (this ProductNameList) Find(name string) *ProductName {
	for _, temp := range this {
		if temp.Name == name {
			return temp
		}
	}
	return nil
}

func (this ProductNameList) Contains(name string) bool {
	if this.Find(name) == nil {
		return false
	}
	return true
}
func (this ProductNameList) SearchKeyword(keyword string) []string {
	list := ProductNameList{}
	for _, temp := range this {
		if temp.ProductType == ProductType_Frozen && strings.Contains(temp.Name, keyword) == true {
			// DebugTrace(fmt.Sprintf("%s 含有关键字 %s ", temp.Name, keyword) + GetFileLocation())
			if list.Contains(temp.Name) == false {
				list = append(list, NewProductName(temp.Name, ProductType_Frozen))
			}
		} else {
			// DebugTrace(fmt.Sprintf("%s 不含有关键字 %s ", temp.Name, keyword) + GetFileLocation())

		}
	}
	return list.ToStringList()
}

// type ProductNameList []string

// func (this ProductNameList) Contains(name string) bool {
// 	for _, temp := range this {
// 		if temp.Name == name {
// 			return true
// 		}
// 	}
// 	return false
// }
type Product struct {
	Barcode string
	Name    string
}

func NewProduct(id, name string) *Product {
	return &Product{
		Barcode: id,
		Name:    name,
	}
}

type ProductList []*Product

func (this ProductList) Add(product *Product) ProductList {
	if this.Contains(product.Barcode, product.Name) {
		return this
	}
	return append(this, product)
}

func (this ProductList) GetProductBarcodeListByName(name string) []string {
	temp := []string{}
	for _, product := range this {
		if name == product.Name {
			temp = append(temp, product.Barcode)
		}
	}
	return temp
}
func (this ProductList) RemoveByName(name string) ProductList {
	temp := ProductList{}
	for _, product := range this {
		if name == product.Name {
			DebugInfo(fmt.Sprintf("查找到了与要删除的产品名称相同的产品信息 %s ", name) + GetFileLocation())
		} else {
			temp = append(temp, product)
		}
	}
	return temp
}
func (this ProductList) Remove(id string) ProductList {
	temp := ProductList{}
	for _, product := range this {
		if id == product.Barcode {
			DebugInfo(fmt.Sprintf("查找到了与要删除的产品编号相同的产品信息 %s %s", id, product.Name) + GetFileLocation())
		} else {
			temp = append(temp, product)
		}
	}
	return temp
}
func (this ProductList) FindByID(id string) *Product {
	for _, product := range this {
		if product.Barcode == id {
			return product
		}
	}
	return nil
}
func (this ProductList) Find(id, name string) *Product {
	for _, product := range this {
		if product.Name == name && product.Barcode == id {
			return product
		}
	}
	return nil
}
func (this ProductList) Contains(id, name string) bool {
	if temp := this.Find(id, name); temp == nil {
		return false
	} else {
		return true
	}
}

// func (this ProductList) SearchKeyword(keyword string) []string {
// 	list := []string{}
// 	for _, product := range this {
// 		if strings.Contains(product.Name, keyword) == true {
// 			if list.Contains(product.Name) == false {
// 				list = append(list, product.Name)
// 			}
// 		} else {
// 			DebugTrace(fmt.Sprintf("名称 %s 中不含有关键字 %s", product.Name, keyword) + GetFileLocation())
// 		}
// 	}
// 	return list
// }
