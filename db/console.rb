require('pry')
require_relative('../models/customer')

Customer.delete_all()

customer1 = Customer.new( 'name' => 'John', 'funds' => '10')
customer2 = Customer.new( 'name' => 'Paul', 'funds' => '2')

customer1.save()
customer2.save()

binding.pry
nil
