# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(name: 'Alan Turing', email: 'alan@locaweb.com.br', password: '12345678', 
            role: 'admin', status: 'active')
User.create(name: 'Linus Torvalds', email: 'vendedor1@locaweb.com.br', password: '12345678', 
            role: 'salesperson', status: 'active')
User.create(name: 'Yukihiro Matsumoto', email: 'vendedor2@locaweb.com.br', password: '12345678', 
            role: 'salesperson', status: :inactive)
User.create(name: 'Administrador', email: 'administrador@locaweb.com.br', password: '12345678', 
            role: 'admin', status: 'active')
User.create(name: 'Vendedor', email: 'vendedor@locaweb.com.br', password: '12345678', 
            role: 'salesperson', status: 'active')

Client.create(eni: '92817341090', name: 'Ada Lovelace', email: 'ada@email.com')
Client.create(eni: '45994858021', name: 'Margaret Hamilton', email: 'margaret@email.com')
Client.create(eni: '35559137006', name: 'Grace Hopper', email: 'grace@email.com')
Client.create(eni: '32586458000160', name: 'CarlosEnterprises', email: 'carlos@email.com',
              eni_status: :inactive, cancellation_reason: 'Falta de pgto')
Client.create(eni: '66899030012', name: 'Carlos', email: 'carlos@email.com', 
              eni_status: :inactive, cancellation_reason: 'Falta de pgto')

Client.create!(name: 'Filipe', email: 'teste@teste.com', eni: '11111111111')

Order.create(status: 'pending', plan_id: 1, period: 'Mensal', client_id: 1, user_id: 2,
             value: '50', client_eni: '92817341090')
Order.create(status: 'pending', plan_id: 1, period: 'Mensal', client_id: 1, user_id: 3,
             value: '50', client_eni: '92817341090')
Order.create(status: :canceled, plan_id: 1, period: 'Semestral', client_id: 3, user_id: 2,
             value: '250', client_eni: '35559137006')
Order.create(status: :canceled, plan_id: 1, period: 'Anual', client_id: 4, user_id: 2,
             value: '500', client_eni: '32586458000160')
Order.create(status: :canceled, plan_id: 1, period: 'Semestral', client_id: 2, user_id: 3,
             value: '250', client_eni: '45994858021')

Order.create(status: :pending, plan_id: 1, period: 'Anual', client_id: 6, user_id: 2,
             value: '500', client_eni: '11111111111')
Order.create(status: :pending, plan_id: 1, period: 'Semestral', client_id: 6, user_id: 3,
             value: '250', client_eni: '11111111111')

Commission.create(value: '15.50', order_id: 1, user_id: 2)
Commission.create(value: '25.50', order_id: 2, user_id: 2)
Commission.create(value: '2.50', order_id: 3, user_id: 3)