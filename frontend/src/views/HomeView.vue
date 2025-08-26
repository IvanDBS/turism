<script setup lang="ts">
import { ref } from 'vue'
import { 
  SunIcon, 
  BuildingOfficeIcon, 
  GlobeAltIcon, 
  SparklesIcon,
  MapIcon,
  HeartIcon
} from '@heroicons/vue/24/outline'

const departureCity = ref('chisinau')
const destination = ref('')
const tourPackage = ref('')
const startDate = ref('2025-09-01')
const nights = ref('3')
const adults = ref('2')
const children = ref('0')

const popularDestinations = ref([
  {
    id: 1,
    name: 'Турция, Анталия',
    description: 'Пляжный отдых на Средиземном море',
    price: 450,
    image: 'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?w=400&h=300&fit=crop'
  },
  {
    id: 2,
    name: 'Греция, Крит',
    description: 'Античная история и кристальные воды',
    price: 520,
    image: 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=400&h=300&fit=crop'
  },
  {
    id: 3,
    name: 'Испания, Барселона',
    description: 'Архитектура Гауди и средиземноморская кухня',
    price: 380,
    image: 'https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop'
  },
  {
    id: 4,
    name: 'Италия, Рим',
    description: 'Вечный город и древние памятники',
    price: 420,
    image: 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop'
  },
  {
    id: 5,
    name: 'ОАЭ, Дубай',
    description: 'Современный мегаполис и пустынные пейзажи',
    price: 680,
    image: 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=400&h=300&fit=crop'
  },
  {
    id: 6,
    name: 'Египет, Хургада',
    description: 'Красное море и древние пирамиды',
    price: 320,
    image: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=300&fit=crop'
  }
])

const categories = ref([
  { id: 1, name: 'Пляжный отдых', count: 156, icon: SunIcon },
  { id: 2, name: 'Городские туры', count: 89, icon: BuildingOfficeIcon },
  { id: 3, name: 'Приключения', count: 67, icon: GlobeAltIcon },
  { id: 4, name: 'Люкс-отдых', count: 34, icon: SparklesIcon },
  { id: 5, name: 'Экскурсии', count: 123, icon: MapIcon },
  { id: 6, name: 'Романтические', count: 45, icon: HeartIcon }
])

const searchTours = () => {
  console.log('Поиск туров:', { 
    departureCity: departureCity.value, 
    destination: destination.value, 
    package: tourPackage.value, 
    startDate: startDate.value, 
    nights: nights.value, 
    adults: adults.value, 
    children: children.value 
  })
}

const selectDestination = (destination: any) => {
  console.log('Выбрано направление:', destination.name)
}

const selectCategory = (category: any) => {
  console.log('Выбрана категория:', category.name)
}
</script>

<template>
  <div class="min-h-screen bg-background">
    <!-- Hero Section -->
    <section class="hero">
      <div class="hero-content">
        <h1 class="hero-title">Найди тур для путешествий</h1>
        <p class="hero-subtitle">Простота. Удобство. Всё в одном месте.</p>
        
        <!-- Search Form -->
        <div class="search-box">
          <div class="search-input">
            <label class="input-label">Город отправления</label>
            <select v-model="departureCity" class="search-select">
              <option value="chisinau">Кишинёв</option>
              <option value="bucuresti">Бухарест</option>
              <option value="barcelona">Барселона</option>
            </select>
          </div>
          <div class="search-input">
            <label class="input-label">Куда</label>
            <input type="text" placeholder="Введите страну курорт или отель" v-model="destination">
          </div>
          <div class="search-input">
            <label class="input-label">Пакет</label>
            <select v-model="tourPackage" class="search-select">
              <option value="">Выберите местность...</option>
              <option value="beach">Пляжный отдых</option>
              <option value="mountain">Горнолыжный</option>
              <option value="city">Городской тур</option>
              <option value="adventure">Приключения</option>
            </select>
          </div>
          <div class="search-input">
            <label class="input-label">Дата</label>
            <input type="date" v-model="startDate">
          </div>
          <div class="search-input">
            <label class="input-label">Ночи</label>
            <select v-model="nights" class="search-select">
              <option value="3">3</option>
              <option value="5">5</option>
              <option value="7">7</option>
              <option value="10">10</option>
              <option value="14">14</option>
            </select>
          </div>
          <div class="search-input">
            <label class="input-label">Взрослые</label>
            <select v-model="adults" class="search-select">
              <option value="1">1</option>
              <option value="2">2</option>
              <option value="3">3</option>
              <option value="4">4</option>
            </select>
          </div>
          <div class="search-input">
            <label class="input-label">Дети</label>
            <select v-model="children" class="search-select">
              <option value="0">0</option>
              <option value="1">1</option>
              <option value="2">2</option>
              <option value="3">3</option>
            </select>
          </div>
          <div class="search-button-container">
            <button class="search-button" @click="searchTours">
              Поиск тура
            </button>
          </div>
        </div>
      </div>
    </section>

    <!-- Value Proposition Block -->
    <section class="value-proposition">
      <div class="value-grid">
        <div class="value-item">
          <div class="value-icon pain">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
            </svg>
            <div class="icon-overlay">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="overlay-icon">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
              </svg>
            </div>
          </div>
          <h3 class="value-title">Устали тратить часы на поиск туров?</h3>
          <p class="value-description">Звонки в агентства и сомнительные предложения? Планирование отпуска стало стрессом вместо удовольствия.</p>
        </div>
        
        <div class="value-item">
          <div class="value-icon solution">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75 11.25 15 15 9.75m-3-7.036A11.959 11.959 0 0 1 3.598 6 11.99 11.99 0 0 0 3 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285Z" />
            </svg>
          </div>
          <h3 class="value-title">Бронируйте тур онлайн за несколько минут</h3>
          <p class="value-description">Выбирайте направления, даты и отели, и получайте проверенные предложения сразу.</p>
        </div>
        
        <div class="value-item">
          <div class="value-icon benefit">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v12m-3-2.818.879.659c1.171.879 3.07.879 4.242 0 1.172-.879 1.172-2.303 0-3.182C13.536 12.219 12.768 12 12 12c-.725 0-1.45-.22-2.003-.659-1.106-.879-1.106-2.303 0-3.182s2.9-.879 4.006 0l.415.33M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
            </svg>
            <div class="icon-overlay">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="overlay-icon">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75 11.25 15 15 9.75m-3-7.036A11.959 11.959 0 0 1 3.598 6 11.99 11.99 0 0 0 3 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285Z" />
              </svg>
            </div>
          </div>
          <h3 class="value-title">Экономия времени, удобство и уверенность</h3>
          <p class="value-description">Ваш отпуск начинается без стресса. Вы выбираете лучшее, не выходя из дома.</p>
        </div>
        
        <div class="value-item">
          <div class="value-icon cta">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M6 12 3.269 3.125A59.769 59.769 0 0 1 21.485 12 59.768 59.768 0 0 1 3.27 20.875L5.999 12Zm0 0h7.5" />
            </svg>
            <div class="icon-overlay">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="overlay-icon">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 12 3.269 3.125A59.769 59.769 0 0 1 21.485 12 59.768 59.768 0 0 1 3.27 20.875L5.999 12Zm0 0h7.5" />
              </svg>
            </div>
          </div>
          <h3 class="value-title">Забронировать тур сейчас</h3>
          <p class="value-description">Начните планировать отпуск своей мечты прямо сейчас</p>
          <button class="cta-button">
            Забронировать тур сейчас
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="cta-arrow">
              <path stroke-linecap="round" stroke-linejoin="round" d="M6 12 3.269 3.125A59.769 59.769 0 0 1 21.485 12 59.768 59.768 0 0 1 3.27 20.875L5.999 12Zm0 0h7.5" />
            </svg>
          </button>
        </div>
      </div>
    </section>

    <!-- Popular Destinations -->
    <section class="section">
      <div class="container">
        <h2 class="section-title">Популярные направления</h2>
        <div class="cards">
          <div 
            v-for="destination in popularDestinations" 
            :key="destination.id"
            class="card"
            @click="selectDestination(destination)"
          >
            <div class="card-image">
              <img :src="destination.image" :alt="destination.name">
            </div>
            <div class="card-body">
              <h3 class="card-title">{{ destination.name }}</h3>
              <p class="card-description">{{ destination.description }}</p>
              <div class="card-price">
                от {{ destination.price }} €
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Categories -->
    <section class="section bg-white">
      <div class="container">
        <h2 class="section-title">Категории туров</h2>
        <div class="categories">
          <div 
            v-for="category in categories" 
            :key="category.id"
            class="category-card"
            @click="selectCategory(category)"
          >
            <div class="category-icon">
              <component :is="category.icon" />
            </div>
            <h3 class="category-title">{{ category.name }}</h3>
            <p class="category-count">{{ category.count }} туров</p>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>
