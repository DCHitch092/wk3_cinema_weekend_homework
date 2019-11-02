require('pry')
require_relative('../models/customer')
require_relative('../models/film')
require_relative('../models/ticket')

Customer.delete_all()
Film.delete_all()
Ticket.delete_all()

customer1 = Customer.new( 'name' => 'John', 'funds' => '10')
customer2 = Customer.new( 'name' => 'Paul', 'funds' => '2')
customer3 = Customer.new( 'name' => 'Ringo', 'funds' => '11')
customer4 = Customer.new( 'name' => 'George', 'funds' => '9')
customer5 = Customer.new( 'name' => 'Paul 2', 'funds' => '100')
customer6 = Customer.new( 'name' => 'Cilla', 'funds' => '20')

customer1.save()
customer2.save()
customer3.save()
customer4.save()
customer5.save()
customer6.save()

film1 = Film.new( 'title' => 'Hard Day\'s Night', 'price' => '5')
film2 = Film.new( 'title' => 'Yellow Flubmarine', 'price' => '7')
film3 = Film.new( 'title' => 'Help!', 'price' => '2')

film1.save()
film2.save()
film3.save()

ticket_01 = Ticket.new( 'customer_id' => customer1.id, 'film_id' => film1.id)
ticket_02 = Ticket.new( 'customer_id' => customer1.id, 'film_id' => film2.id)
ticket_03 = Ticket.new( 'customer_id' => customer1.id, 'film_id' => film3.id)
ticket_04 = Ticket.new( 'customer_id' => customer2.id, 'film_id' => film2.id)
ticket_05 = Ticket.new( 'customer_id' => customer2.id, 'film_id' => film1.id)
ticket_06 = Ticket.new( 'customer_id' => customer3.id, 'film_id' => film2.id)
ticket_07 = Ticket.new( 'customer_id' => customer4.id, 'film_id' => film3.id)
ticket_08 = Ticket.new( 'customer_id' => customer4.id, 'film_id' => film2.id)

ticket_01.save
ticket_02.save
ticket_03.save
ticket_04.save
ticket_05.save
ticket_06.save
ticket_07.save
ticket_08.save

binding.pry
nil
