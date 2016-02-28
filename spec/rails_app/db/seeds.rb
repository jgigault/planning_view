c1 = Category.create name: 'Category 1'
c2 = Category.create name: 'Category 2'
c3 = Category.create name: 'Category 3'

Project.create name: 'Project 1', category: c1
Project.create name: 'Project 2', category: c1
Project.create name: 'Project 3', category: c1
Project.create name: 'Project 4', category: c1
Project.create name: 'Project 5', category: c1
Project.create name: 'Project 6', category: c1, negotiation_start: Date.today - 3.months, negotiation_end: Date.today + 1.month + 15.days
