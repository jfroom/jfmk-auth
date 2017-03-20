# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rails db:seed command
# or created alongside the database with db:setup.
#
# Examples:
#
# movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# Character.create(name: 'Luke', movie: movies.first)

User.create [
                {username: 'admin', password: 'Secret1', name: 'Admin', admin: true},
                {username: 'user', password: 'Secret1', name: 'User'}
            ]
