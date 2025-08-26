<template>
  <div class="tours">
    <div class="container">
      <h1 class="page-title">Все направления</h1>
      
      <!-- Filters -->
      <div class="filters">
        <div class="filter-group">
          <label>Категория:</label>
          <select v-model="selectedCategory" class="filter-select">
            <option value="">Все категории</option>
            <option value="beach">Пляжный отдых</option>
            <option value="mountain">Горнолыжный</option>
            <option value="city">Городской тур</option>
            <option value="cultural">Культурный</option>
            <option value="adventure">Приключения</option>
          </select>
        </div>
        
        <div class="filter-group">
          <label>Цена:</label>
          <select v-model="priceRange" class="filter-select">
            <option value="">Любая цена</option>
            <option value="0-300">До 300€</option>
            <option value="300-500">300-500€</option>
            <option value="500-800">500-800€</option>
            <option value="800+">От 800€</option>
          </select>
        </div>
      </div>

      <!-- Tours Grid -->
      <div class="tours-grid">
        <div 
          v-for="tour in filteredTours" 
          :key="tour.id"
          class="tour-card"
          @click="selectTour(tour)"
        >
          <div class="tour-image">
            <img :src="tour.image" :alt="tour.name">
            <div v-if="tour.deal" class="tour-badge">{{ tour.deal }}</div>
          </div>
          <div class="tour-content">
            <h3 class="tour-title">{{ tour.name }}</h3>
            <p class="tour-description">{{ tour.description }}</p>
            <div class="tour-details">
              <span class="tour-duration">{{ tour.duration }} дней</span>
              <span class="tour-category">{{ tour.category }}</span>
            </div>
            <div class="tour-footer">
              <span class="tour-price">от {{ tour.price }}€</span>
              <button class="tour-button">Забронировать</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

const selectedCategory = ref('')
const priceRange = ref('')

const tours = ref([
  {
    id: 1,
    name: 'Турция, Анталия',
    description: 'Пляжный отдых на Средиземном море с экскурсиями',
    price: 450,
    duration: 7,
    category: 'Пляжный отдых',
    image: 'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?w=400&h=300&fit=crop',
    deal: 'Хит продаж'
  },
  {
    id: 2,
    name: 'Греция, Крит',
    description: 'Античная история и кристальные воды Эгейского моря',
    price: 520,
    duration: 10,
    category: 'Культурный',
    image: 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=400&h=300&fit=crop'
  },
  {
    id: 3,
    name: 'Испания, Барселона',
    description: 'Архитектура Гауди и средиземноморская кухня',
    price: 380,
    duration: 5,
    category: 'Городской тур',
    image: 'https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop',
    deal: 'Скидка 15%'
  },
  {
    id: 4,
    name: 'Италия, Рим',
    description: 'Вечный город и древние памятники',
    price: 420,
    duration: 6,
    category: 'Культурный',
    image: 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop'
  },
  {
    id: 5,
    name: 'ОАЭ, Дубай',
    description: 'Современный мегаполис и пустынные пейзажи',
    price: 680,
    duration: 8,
    category: 'Городской тур',
    image: 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=400&h=300&fit=crop'
  },
  {
    id: 6,
    name: 'Египет, Хургада',
    description: 'Красное море и древние пирамиды',
    price: 320,
    duration: 7,
    category: 'Пляжный отдых',
    image: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=300&fit=crop'
  }
])

const filteredTours = computed(() => {
  let filtered = tours.value

  if (selectedCategory.value) {
    filtered = filtered.filter(tour => tour.category === selectedCategory.value)
  }

  if (priceRange.value) {
    const [min, max] = priceRange.value.split('-').map(Number)
    if (max) {
      filtered = filtered.filter(tour => tour.price >= min && tour.price <= max)
    } else {
      filtered = filtered.filter(tour => tour.price >= min)
    }
  }

  return filtered
})

const selectTour = (tour: any) => {
  console.log('Выбран тур:', tour.name)
}
</script>

<style scoped>
.tours {
  padding: 80px 20px;
  background: white;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
}

.page-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: var(--dark);
  text-align: center;
  margin-bottom: 40px;
}

.filters {
  display: flex;
  gap: 20px;
  margin-bottom: 40px;
  justify-content: center;
  flex-wrap: wrap;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.filter-group label {
  font-weight: 600;
  color: var(--dark);
  font-size: 0.9rem;
}

.filter-select {
  padding: 8px 12px;
  border: 1px solid var(--border);
  border-radius: 6px;
  font-size: 0.9rem;
  background: white;
}

.tours-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 30px;
}

.tour-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
  cursor: pointer;
}

.tour-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
}

.tour-image {
  position: relative;
  height: 200px;
  overflow: hidden;
}

.tour-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.tour-card:hover .tour-image img {
  transform: scale(1.05);
}

.tour-badge {
  position: absolute;
  top: 12px;
  left: 12px;
  background: var(--accent);
  color: white;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.8rem;
  font-weight: 600;
}

.tour-content {
  padding: 20px;
}

.tour-title {
  font-size: 1.2rem;
  font-weight: 600;
  color: var(--dark);
  margin: 0 0 8px 0;
}

.tour-description {
  color: var(--secondary-text);
  font-size: 0.9rem;
  line-height: 1.5;
  margin: 0 0 15px 0;
}

.tour-details {
  display: flex;
  gap: 15px;
  margin-bottom: 15px;
}

.tour-duration,
.tour-category {
  font-size: 0.8rem;
  color: var(--secondary-text);
  background: var(--background);
  padding: 4px 8px;
  border-radius: 4px;
}

.tour-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.tour-price {
  font-size: 1.1rem;
  font-weight: 700;
  color: var(--accent);
}

.tour-button {
  background: var(--accent);
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 0.9rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.tour-button:hover {
  background: #e04a4f;
  transform: translateY(-1px);
}

@media (max-width: 768px) {
  .tours {
    padding: 60px 20px;
  }
  
  .page-title {
    font-size: 2rem;
  }
  
  .tours-grid {
    grid-template-columns: 1fr;
  }
  
  .filters {
    flex-direction: column;
    align-items: center;
  }
}
</style>
