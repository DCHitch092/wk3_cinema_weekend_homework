

db codeclan_cinema
db/codeclan_cinema.sql
db/SqlRunner.rb
db/console.rb

##customers table
models/customer.rb
- name
- funds
- id

save()
update()
delete()
delete_all()
check_films()
buy_ticket()

##films table
models/film.rb
- id
- title
- price

save()
update()
delete()
delete_all()
check_customers()

##tickets table
models/tickets.rb
- id
- customer_id
- film_id

save()
update()
delete()
delete_all()
-----------------
check_ticket_total(customer)
most_sales() --> PDA
+++++++++
check_film_sales(film)

+++++++++++++++++
##screenings table
models/screening.rb
- id
- time
- film_id
- seats

save()
update()
delete()
delete_all()
most_popular_screening_time()
reserve_seat()
seat_check()
