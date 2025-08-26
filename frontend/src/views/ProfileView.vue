<template>
  <div class="profile">
    <div class="container">
      <h1 class="page-title">Мой профиль</h1>
      
      <div class="profile-content">
        <!-- User Info -->
        <div class="profile-section">
          <h2>Личная информация</h2>
          <div class="user-info">
            <div class="avatar">
              <span>{{ userInitials }}</span>
            </div>
            <div class="user-details">
              <h3>{{ user.name }}</h3>
              <p>{{ user.email }}</p>
              <p class="member-since">Участник с {{ user.joinDate }}</p>
            </div>
          </div>
        </div>

        <!-- My Bookings -->
        <div class="profile-section">
          <h2>Мои бронирования</h2>
          <div v-if="bookings.length === 0" class="empty-state">
            <p>У вас пока нет забронированных туров</p>
            <router-link to="/tours" class="browse-button">
              Найти тур
            </router-link>
          </div>
          <div v-else class="bookings-list">
            <div 
              v-for="booking in bookings" 
              :key="booking.id"
              class="booking-card"
            >
              <div class="booking-image">
                <img :src="booking.tourImage" :alt="booking.tourName">
              </div>
              <div class="booking-details">
                <h3>{{ booking.tourName }}</h3>
                <p class="booking-dates">{{ booking.startDate }} - {{ booking.endDate }}</p>
                <p class="booking-guests">{{ booking.guests }} гостей</p>
                <div class="booking-status" :class="booking.status">
                  {{ getStatusText(booking.status) }}
                </div>
              </div>
              <div class="booking-price">
                <span class="price">{{ booking.totalPrice }}€</span>
                <button class="view-button">Подробнее</button>
              </div>
            </div>
          </div>
        </div>

        <!-- Settings -->
        <div class="profile-section">
          <h2>Настройки</h2>
          <div class="settings">
            <div class="setting-item">
              <div class="setting-info">
                <h3>Уведомления</h3>
                <p>Получать уведомления о новых предложениях</p>
              </div>
              <label class="toggle">
                <input type="checkbox" v-model="settings.notifications">
                <span class="slider"></span>
              </label>
            </div>
            
            <div class="setting-item">
              <div class="setting-info">
                <h3>Email рассылка</h3>
                <p>Получать специальные предложения на email</p>
              </div>
              <label class="toggle">
                <input type="checkbox" v-model="settings.emailMarketing">
                <span class="slider"></span>
              </label>
            </div>
          </div>
        </div>

        <!-- Actions -->
        <div class="profile-actions">
          <button @click="logout" class="logout-button">
            Выйти из аккаунта
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { useRouter } from 'vue-router'

const authStore = useAuthStore()
const router = useRouter()

const user = ref({
  name: 'Иван Петров',
  email: 'ivan@example.com',
  joinDate: 'Январь 2025'
})

const bookings = ref([
  {
    id: 1,
    tourName: 'Турция, Анталия',
    startDate: '15.09.2025',
    endDate: '22.09.2025',
    guests: 2,
    totalPrice: 900,
    status: 'confirmed',
    tourImage: 'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?w=400&h=300&fit=crop'
  }
])

const settings = ref({
  notifications: true,
  emailMarketing: false
})

const userInitials = computed(() => {
  return user.value.name.split(' ').map(n => n[0]).join('')
})

const getStatusText = (status: string) => {
  const statusMap = {
    'pending': 'Ожидает подтверждения',
    'confirmed': 'Подтверждено',
    'cancelled': 'Отменено',
    'completed': 'Завершено'
  }
  return statusMap[status as keyof typeof statusMap] || status
}

const logout = () => {
  authStore.logout()
  router.push('/')
}
</script>

<style scoped>
.profile {
  padding: 80px 20px;
  background: white;
}

.container {
  max-width: 800px;
  margin: 0 auto;
}

.page-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: var(--dark);
  text-align: center;
  margin-bottom: 60px;
}

.profile-content {
  display: flex;
  flex-direction: column;
  gap: 40px;
}

.profile-section {
  background: var(--background);
  padding: 30px;
  border-radius: 12px;
}

.profile-section h2 {
  font-size: 1.5rem;
  font-weight: 600;
  color: var(--dark);
  margin: 0 0 20px 0;
}

.user-info {
  display: flex;
  gap: 20px;
  align-items: center;
}

.avatar {
  width: 80px;
  height: 80px;
  background: linear-gradient(135deg, var(--primary), var(--secondary));
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 1.5rem;
  font-weight: 600;
}

.user-details h3 {
  font-size: 1.3rem;
  font-weight: 600;
  color: var(--dark);
  margin: 0 0 8px 0;
}

.user-details p {
  color: var(--secondary-text);
  margin: 0 0 4px 0;
}

.member-since {
  font-size: 0.9rem;
  color: #999 !important;
}

.empty-state {
  text-align: center;
  padding: 40px 20px;
}

.empty-state p {
  color: var(--secondary-text);
  margin-bottom: 20px;
}

.browse-button {
  background: var(--accent);
  color: white;
  text-decoration: none;
  padding: 12px 24px;
  border-radius: 6px;
  font-weight: 600;
  transition: all 0.2s ease;
}

.browse-button:hover {
  background: #e04a4f;
  transform: translateY(-1px);
}

.bookings-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.booking-card {
  display: flex;
  gap: 20px;
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.booking-image {
  width: 100px;
  height: 70px;
  border-radius: 6px;
  overflow: hidden;
  flex-shrink: 0;
}

.booking-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.booking-details {
  flex: 1;
}

.booking-details h3 {
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--dark);
  margin: 0 0 8px 0;
}

.booking-dates,
.booking-guests {
  color: var(--secondary-text);
  font-size: 0.9rem;
  margin: 0 0 4px 0;
}

.booking-status {
  display: inline-block;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.8rem;
  font-weight: 600;
  margin-top: 8px;
}

.booking-status.confirmed {
  background: #d4edda;
  color: #155724;
}

.booking-status.pending {
  background: #fff3cd;
  color: #856404;
}

.booking-status.cancelled {
  background: #f8d7da;
  color: #721c24;
}

.booking-price {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 10px;
}

.price {
  font-size: 1.2rem;
  font-weight: 700;
  color: var(--accent);
}

.view-button {
  background: transparent;
  color: var(--primary);
  border: 1px solid var(--primary);
  padding: 6px 12px;
  border-radius: 4px;
  font-size: 0.8rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.view-button:hover {
  background: var(--primary);
  color: white;
}

.settings {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.setting-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 0;
  border-bottom: 1px solid var(--border);
}

.setting-item:last-child {
  border-bottom: none;
}

.setting-info h3 {
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--dark);
  margin: 0 0 4px 0;
}

.setting-info p {
  color: var(--secondary-text);
  font-size: 0.9rem;
  margin: 0;
}

.toggle {
  position: relative;
  display: inline-block;
  width: 50px;
  height: 24px;
}

.toggle input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  transition: .4s;
  border-radius: 24px;
}

.slider:before {
  position: absolute;
  content: "";
  height: 18px;
  width: 18px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  transition: .4s;
  border-radius: 50%;
}

input:checked + .slider {
  background-color: var(--accent);
}

input:checked + .slider:before {
  transform: translateX(26px);
}

.profile-actions {
  display: flex;
  justify-content: center;
  padding-top: 20px;
}

.logout-button {
  background: transparent;
  color: #dc3545;
  border: 1px solid #dc3545;
  padding: 12px 24px;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

.logout-button:hover {
  background: #dc3545;
  color: white;
}

@media (max-width: 768px) {
  .profile {
    padding: 60px 20px;
  }
  
  .page-title {
    font-size: 2rem;
  }
  
  .booking-card {
    flex-direction: column;
  }
  
  .booking-price {
    align-items: flex-start;
  }
  
  .setting-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }
}
</style>
