# Use this file to import the sales information into the
# the database.

require "pg"
require "csv"
require "pry"

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end

data = CSV.read("sales.csv", headers:true)

db_connection do |conn|
  data.each do |line|
    employee = line["employee"]
    conn.exec_params("INSERT INTO employees (name) SELECT ($1) WHERE NOT EXISTS (SELECT * FROM employees WHERE name = ($1))", [employee])
    customer = line["customer_and_account_no"]
    conn.exec_params("INSERT INTO customers (name) SELECT ($1) WHERE NOT EXISTS (SELECT * FROM customers WHERE name = ($1))", [customer])
    product = line["product_name"]
    conn.exec_params("INSERT INTO products (name) SELECT ($1) WHERE NOT EXISTS (SELECT * FROM products WHERE name = ($1))", [product])
    invoice_frequency = line["invoice_frequency"]
    conn.exec_params("INSERT INTO invoice_frequency (type) SELECT ($1) WHERE NOT EXISTS (SELECT * FROM invoice_frequency WHERE type = ($1))", [invoice_frequency])
    invoice_number = line["invoice_no"]
    # binding.pry
    conn.exec_params("INSERT INTO sales (invoice_number) SELECT ($1) WHERE NOT EXISTS (SELECT * FROM sales WHERE invoice_number = ($1))", [invoice_number])
    amount = line["sale_amount"]
    date = line["sale_date"]
    units = line["units_sold"]
    conn.exec_params("UPDATE sales SET date = ($1), amount = ($2), units = ($3) WHERE invoice_number = ($4)", [date, amount, units, invoice_number])
    conn.exec_params("UPDATE sales SET employee_id = (SELECT id FROM employees WHERE employees.name = ($1)) WHERE invoice_number = ($2)", [employee, invoice_number])
    conn.exec_params("UPDATE sales SET customer_id = (SELECT id FROM customers WHERE customers.name = ($1)) WHERE invoice_number = ($2)", [customer, invoice_number])
    # binding.pry
    conn.exec_params("UPDATE sales SET product_id = (SELECT id FROM products WHERE products.name = ($1)) WHERE invoice_number = ($2)", [product, invoice_number])
    conn.exec_params("UPDATE sales SET invoice_frequency_id = (SELECT id FROM invoice_frequency WHERE invoice_frequency.type = ($1)) WHERE invoice_number = ($2)", [invoice_frequency, invoice_number])
  end
end
