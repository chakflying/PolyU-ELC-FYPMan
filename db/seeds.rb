# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Initialize with departments list updated in Oct 2018
#  Department.create(name: "Department of Applied Biology and Chemical Technology", code: "ABCT")
#  Department.create(name: "Department of Applied Mathematics", code: "AMA")
#  Department.create(name: "Department of Applied Physics", code: "AP")
#  Department.create(name: "Institute of Textiles and Clothing", code: "ITC")
#  Department.create(name: "School of Accounting and Finance", code: "AF")
#  Department.create(name: "Department of Logistics and Maritime Studies", code: "LMS")
#  Department.create(name: "Department of Management and Marketing", code: "MM")
#  Department.create(name: "Department of Building and Real Estate", code: "BRE")
#  Department.create(name: "Department of Building Services Engineering", code: "BSE")
#  Department.create(name: "Department of Civil and Environmental Engineering", code: "CEE")
#  Department.create(name: "Department of Land Surveying and Geo-Informatics", code: "LSGI")
#  Department.create(name: "Department of Biomedical Engineering", code: "BME")
#  Department.create(name: "Department of Computing", code: "COMP")
#  Department.create(name: "Department of Electrical Engineering", code: "EE")
#  Department.create(name: "Department of Electronic and Information Engineering", code: "EIE")
#  Department.create(name: "Department of Industrial and Systems Engineering", code: "ISE")
#  Department.create(name: "Department of Mechanical Engineering", code: "ME")
#  Department.create(name: "Interdisciplinary Division of Aeronautical and Aviation Engineering", code: "AAE")
#  Department.create(name: "Department of Applied Social Sciences", code: "APSS")
#  Department.create(name: "Department of Health Technology and Informatics", code: "HTI")
#  Department.create(name: "Department of Rehabilitation Sciences", code: "RS")
#  Department.create(name: "School of Nursing", code: "SN")
#  Department.create(name: "School of Optometry", code: "SO")
#  Department.create(name: "Department of Chinese and Bilingual Studies", code: "CBS")
#  Department.create(name: "Department of Chinese Culture", code: "CC")
#  Department.create(name: "Department of English", code: "ENGL")
#  Department.create(name: "Confucius Institute of Hong Kong", code: "CIHK")
#  Department.create(name: "English Language Centre", code: "ELC")
#  Department.create(name: "General Education Centre", code: "GEC")
#  Department.create(name: "School of Design", code: "SD")
#  Department.create(name: "School of Hotel and Tourism Management", code: "SHTM")

require 'faker'
if Department.first.present?
  Dep = Department.first.id
  2000.times do
    n = Faker::Name.name
    netID = Faker::Internet.slug(n)
    Student.create(
      name: n,
      netID: netID,
      fyp_year: '2018-2019',
      department_id: Dep
    )
  end
end
