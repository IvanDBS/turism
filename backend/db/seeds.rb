# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Creating tours..."

# Удаляем существующие данные
Tour.destroy_all
User.destroy_all

# Создаем тестового пользователя
user = User.create!(
  email: 'test@example.com',
  name: 'Test User',
  password: 'password123',
  password_confirmation: 'password123',
  role: 'user'
)

# Создаем туры
tours = [
  {
    title: "Пляжный отдых на Бали",
    description: "Незабываемый отдых на лучших пляжах Бали. Включены трансферы, проживание в 4-звездочном отеле, завтраки и экскурсии.",
    price: 1200.00,
    duration: 7,
    destination: "Бали, Индонезия",
    image_url: "https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?w=800",
    category: "beach"
  },
  {
    title: "Горнолыжный курорт в Альпах",
    description: "Покорение склонов в лучших горнолыжных курортах Альп. Прокат оборудования, инструктор и проживание включены.",
    price: 1800.00,
    duration: 5,
    destination: "Шамони, Франция",
    image_url: "https://images.unsplash.com/photo-1551524164-4876eb6e32a8?w=800",
    category: "mountain"
  },
  {
    title: "Культурное путешествие по Парижу",
    description: "Погружение в культуру и искусство Парижа. Посещение Лувра, Эйфелевой башни, Нотр-Дама и других достопримечательностей.",
    price: 950.00,
    duration: 4,
    destination: "Париж, Франция",
    image_url: "https://images.unsplash.com/photo-1502602898535-0b7b0c8c8c8c?w=800",
    category: "cultural"
  },
  {
    title: "Приключения в джунглях Амазонки",
    description: "Экстремальное путешествие в сердце Амазонки. Сплав по реке, трекинг, наблюдение за дикой природой.",
    price: 2200.00,
    duration: 10,
    destination: "Манаус, Бразилия",
    image_url: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
    category: "adventure"
  },
  {
    title: "Люкс-отдых на Мальдивах",
    description: "Эксклюзивный отдых в бунгало над водой. Включены трансферы на гидросамолете, все включено питание, спа-процедуры.",
    price: 3500.00,
    duration: 7,
    destination: "Мальдивы",
    image_url: "https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800",
    category: "luxury"
  },
  {
    title: "Городское путешествие по Токио",
    description: "Современный мегаполис и традиционная культура Японии. Посещение храмов, неоновых кварталов, ресторанов.",
    price: 1400.00,
    duration: 6,
    destination: "Токио, Япония",
    image_url: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800",
    category: "city"
  }
]

tours.each do |tour_data|
  Tour.create!(tour_data)
end

puts "Created #{Tour.count} tours"
puts "Created user: #{user.email} (password: password123)"
