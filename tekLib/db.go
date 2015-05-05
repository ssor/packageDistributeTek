package tekLib

import (
	"database/sql"
	"fmt"
	"github.com/coopernurse/gorp"
	_ "github.com/mattn/go-sqlite3"
	// "errors"
)

//==============================================================================================
var g_surport_write_db bool = true
var g_db *gorp.DbMap

func InitDB() error {
	// return
	var err error
	g_db, err = initDb()
	if err != nil {
		return err
	}
	return nil
}

//==============================================================================================

func GetAllProductsFromDB() (ProductList, error) {
	var products ProductList
	if _, err := g_db.Select(&products, "select * from products"); err != nil {
		return nil, err
	} else {
		return products, nil
	}
}
func RemoveProductOnly(productID string) error {
	if g_surport_write_db == false {
		return nil
	}

	if _, err := g_db.Exec(fmt.Sprintf("delete from products where Barcode = '%s'", productID)); err != nil {
		return err
	} else {
		return nil
	}
}
func AddProductOnly(product *Product) error {
	if g_surport_write_db == false {
		return nil
	}

	err := g_db.Insert(product)
	if err != nil {
		return err
	} else {
		return nil
	}
}
func RemoveProductNameOnly(name string) error {
	if g_surport_write_db == false {
		return nil
	}

	if _, err := g_db.Exec(fmt.Sprintf("delete from productName where Name = '%s'", name)); err != nil {
		return err
	} else {
		return nil
	}
}
func AddProductNameOnly(name string, productType int) error {
	if g_surport_write_db == false {
		return nil
	}

	err := g_db.Insert(NewProductName(name, productType))
	if err != nil {
		return err
	} else {
		return nil
	}
}
func GetAllProductNameFromDB() (ProductNameList, error) {
	var list ProductNameList
	if _, err := g_db.Select(&list, "select Name from productName"); err != nil {
		return nil, err
	} else {
		return list, nil
	}
}

//==============================================================================================

func initDb() (*gorp.DbMap, error) {
	// connect to db using standard Go database/sql API
	// use whatever database/sql driver you wish
	db, err := sql.Open("sqlite3", "./db.db3")
	if err != nil {
		return nil, err
	}

	// construct a gorp DbMap
	dbmap := &gorp.DbMap{Db: db, Dialect: gorp.SqliteDialect{}}

	// add a table, setting the table name to 'posts' and
	// specifying that the Id property is an auto incrementing PK
	dbmap.AddTableWithName(Product{}, "products").SetKeys(false, "Barcode", "Name")
	dbmap.AddTableWithName(ProductName{}, "productName").SetKeys(false, "Name")
	// return nil
	// create the table. in a production system you'd generally
	// use a migration tool, or create the tables via scripts
	if err := dbmap.CreateTablesIfNotExists(); err != nil {
		// DebugOutput("创建数据库表失败"+getFileLocation(), 1)
		return nil, err
		// checkErr(err, "Create tables failed")
	}

	return dbmap, nil
}
