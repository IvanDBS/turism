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
    description: "Незабываемый отдых на лучших пляжах Бали. Включены трансферы, проживание в 4-звездочном отеле, завтраки и экскурсии. Идеально для семейного отдыха и романтических путешествий.",
    price: 1200.00,
    duration: 7,
    destination: "Бали, Индонезия",
    image_url: "https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?w=800",
    category: "beach",
    departure_city: "Кишинёв",
    start_date: Date.parse("2025-03-15"),
    end_date: Date.parse("2025-03-22"),
    max_travelers: 20,
    min_travelers: 2,
    included_services: "Проживание в отеле 4*, трансферы, завтраки, экскурсии, страховка",
    not_included_services: "Авиабилеты, обеды и ужины, личные расходы",
    itinerary: "День 1: Прибытие в Денпасар, трансфер в отель\nДень 2-6: Отдых на пляже, экскурсии\nДень 7: Возвращение",
    accommodation_type: "hotel",
    transport_type: "plane",
    is_featured: true,
    rating: 4.8,
    reviews_count: 45
  },
  {
    title: "Горнолыжный курорт в Альпах",
    description: "Покорение склонов в лучших горнолыжных курортах Альп. Прокат оборудования, инструктор и проживание включены. Подходит для активного зимнего отдыха.",
    price: 1800.00,
    duration: 5,
    destination: "Шамони, Франция",
    image_url: "https://images.unsplash.com/photo-1551524164-4876eb6e32a8?w=800",
    category: "mountain",
    departure_city: "Кишинёв",
    start_date: Date.parse("2025-01-20"),
    end_date: Date.parse("2025-01-25"),
    max_travelers: 15,
    min_travelers: 1,
    included_services: "Проживание в отеле, ски-пасс, прокат оборудования, инструктор",
    not_included_services: "Авиабилеты, питание, личные расходы",
    itinerary: "День 1: Прибытие в Шамони\nДень 2-4: Катание на лыжах\nДень 5: Возвращение",
    accommodation_type: "hotel",
    transport_type: "plane",
    is_featured: false,
    rating: 4.6,
    reviews_count: 32
  },
  {
    title: "Культурное путешествие по Парижу",
    description: "Погружение в культуру и искусство Парижа. Посещение Лувра, Эйфелевой башни, Нотр-Дама и других достопримечательностей. Идеально для ценителей искусства и истории.",
    price: 950.00,
    duration: 4,
    destination: "Париж, Франция",
    image_url: "https://images.unsplash.com/photo-1502602898535-0b7b0c8c8c8c?w=800",
    category: "cultural",
    departure_city: "Кишинёв",
    start_date: Date.parse("2025-04-10"),
    end_date: Date.parse("2025-04-14"),
    max_travelers: 25,
    min_travelers: 2,
    included_services: "Проживание в центре города, экскурсии с гидом, музейные билеты",
    not_included_services: "Авиабилеты, питание, личные расходы",
    itinerary: "День 1: Эйфелева башня, Елисейские поля\nДень 2: Лувр, Нотр-Дам\nДень 3: Версаль\nДень 4: Монмартр",
    accommodation_type: "hotel",
    transport_type: "plane",
    is_featured: true,
    rating: 4.9,
    reviews_count: 67
  },
  {
    title: "Приключения в джунглях Амазонки",
    description: "Экстремальное путешествие в сердце Амазонки. Сплав по реке, трекинг, наблюдение за дикой природой. Для любителей экстремального туризма.",
    price: 2200.00,
    duration: 10,
    destination: "Манаус, Бразилия",
    image_url: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
    category: "adventure",
    departure_city: "Кишинёв",
    start_date: Date.parse("2025-06-01"),
    end_date: Date.parse("2025-06-11"),
    max_travelers: 12,
    min_travelers: 4,
    included_services: "Проживание в лоджах, все экскурсии, питание, гид",
    not_included_services: "Авиабилеты, страховка, личные расходы",
    itinerary: "День 1-3: Манаус, знакомство с регионом\nДень 4-8: Джунгли, сплав по реке\nДень 9-10: Возвращение",
    accommodation_type: "resort",
    transport_type: "plane",
    is_featured: false,
    rating: 4.7,
    reviews_count: 18
  },
  {
    title: "Люкс-отдых на Мальдивах",
    description: "Эксклюзивный отдых в бунгало над водой. Включены трансферы на гидросамолете, все включено питание, спа-процедуры. Максимальный комфорт и роскошь.",
    price: 3500.00,
    duration: 7,
    destination: "Мальдивы",
    image_url: "https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800",
    category: "luxury",
    departure_city: "Кишинёв",
    start_date: Date.parse("2025-05-15"),
    end_date: Date.parse("2025-05-22"),
    max_travelers: 8,
    min_travelers: 2,
    included_services: "Бунгало над водой, все включено, спа-процедуры, трансферы на гидросамолете",
    not_included_services: "Авиабилеты, алкоголь, личные расходы",
    itinerary: "День 1: Прибытие, размещение в бунгало\nДень 2-6: Отдых, спа, дайвинг\nДень 7: Возвращение",
    accommodation_type: "resort",
    transport_type: "plane",
    is_featured: true,
    rating: 5.0,
    reviews_count: 23
  },
  {
    title: "Городское путешествие по Токио",
    description: "Современный мегаполис и традиционная культура Японии. Посещение храмов, неоновых кварталов, ресторанов. Погружение в японскую культуру.",
    price: 1400.00,
    duration: 6,
    destination: "Токио, Япония",
    image_url: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800",
    category: "city",
    departure_city: "Кишинёв",
    start_date: Date.parse("2025-07-01"),
    end_date: Date.parse("2025-07-07"),
    max_travelers: 18,
    min_travelers: 2,
    included_services: "Проживание в отеле, экскурсии, транспортная карта",
    not_included_services: "Авиабилеты, питание, личные расходы",
    itinerary: "День 1: Синдзюку, Токио Скай Три\nДень 2: Сибуя, Харадзюку\nДень 3: Асакуса, храмы\nДень 4: Гиндза, Цукидзи\nДень 5: Одайба\nДень 6: Возвращение",
    accommodation_type: "hotel",
    transport_type: "plane",
    is_featured: false,
    rating: 4.5,
    reviews_count: 41
  },
  {
    title: "Романтический тур в Венецию",
    description: "Романтическое путешествие в город на воде. Гондолы, закаты, итальянская кухня. Идеально для влюбленных пар.",
    price: 1100.00,
    duration: 5,
    destination: "Венеция, Италия",
    image_url: "https://images.unsplash.com/photo-1523906834658-6e24ef2386f9?w=800",
    category: "romantic",
    departure_city: "Кишинёв",
    start_date: Date.parse("2025-02-14"),
    end_date: Date.parse("2025-02-19"),
    max_travelers: 16,
    min_travelers: 2,
    included_services: "Проживание в историческом центре, прогулка на гондоле, романтический ужин",
    not_included_services: "Авиабилеты, дополнительные экскурсии, личные расходы",
    itinerary: "День 1: Прибытие, прогулка по городу\nДень 2: Сан-Марко, Дворец дожей\nДень 3: Гондола, острова\nДень 4: Свободное время\nДень 5: Возвращение",
    accommodation_type: "hotel",
    transport_type: "plane",
    is_featured: true,
    rating: 4.8,
    reviews_count: 29
  },
  {
    title: "Семейный отдых в Диснейленде",
    description: "Волшебное путешествие для всей семьи в мир Диснея. Аттракционы, шоу, встречи с персонажами. Незабываемые впечатления для детей и взрослых.",
    price: 1600.00,
    duration: 8,
    destination: "Париж, Франция",
    image_url: "https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800",
    category: "family",
    departure_city: "Кишинёв",
    start_date: Date.parse("2025-08-01"),
    end_date: Date.parse("2025-08-09"),
    max_travelers: 30,
    min_travelers: 3,
    included_services: "Проживание в отеле Дисней, билеты в парк, трансферы",
    not_included_services: "Авиабилеты, питание в парке, сувениры",
    itinerary: "День 1: Прибытие, размещение\nДень 2-7: Диснейленд, Дисней Студиос\nДень 8: Возвращение",
    accommodation_type: "hotel",
    transport_type: "plane",
    is_featured: false,
    rating: 4.6,
    reviews_count: 38
  }
]

tours.each do |tour_data|
  Tour.create!(tour_data)
end

puts "Created #{Tour.count} tours"
puts "Created user: #{user.email} (password: password123)"
