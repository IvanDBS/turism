<script setup lang="ts">
import { ref, computed } from 'vue'
import { useAuthStore } from '@/stores/auth'
import AuthModal from '@/components/AuthModal.vue'

const authStore = useAuthStore()
const showLoginModal = ref(false)
const showRegisterModal = ref(false)

const isAuthenticated = computed(() => authStore.isAuthenticated)

const handleAuthSuccess = () => {
  showLoginModal.value = false
  showRegisterModal.value = false
}

const logout = () => {
  authStore.logout()
}
</script>

<template>
  <header>
    <nav>
      <div class="nav-container">
        <div class="nav-content">
          <!-- Logo -->
          <router-link to="/" class="logo">
            migo.md
          </router-link>

          <!-- Navigation Links -->
          <div class="nav-links">
            <router-link to="/" class="nav-link">
              Главная
            </router-link>
            <router-link to="/tours" class="nav-link">
              Направления
            </router-link>
            <router-link to="/about" class="nav-link">
              Контакты
            </router-link>
          </div>

          <!-- Auth Buttons -->
          <div class="nav-auth">
            <button 
              v-if="!isAuthenticated"
              @click="showLoginModal = true"
              class="btn-outline"
            >
              Войти
            </button>
            <button 
              v-if="!isAuthenticated"
              @click="showRegisterModal = true"
              class="btn-primary"
            >
              Регистрация
            </button>
            <div v-else class="nav-auth">
              <router-link to="/profile" class="nav-link">
                Профиль
              </router-link>
              <button @click="logout" class="btn-outline">
                Выйти
              </button>
            </div>
          </div>
        </div>
      </div>
    </nav>

    <!-- Auth Modals -->
    <AuthModal 
      v-if="showLoginModal" 
      mode="login" 
      @close="showLoginModal = false"
      @success="handleAuthSuccess"
    />
    <AuthModal 
      v-if="showRegisterModal" 
      mode="register" 
      @close="showRegisterModal = false"
      @success="handleAuthSuccess"
    />
  </header>
</template>

<style scoped>
.btn-outline {
  background: transparent;
  color: var(--secondary-text);
  border: 1px solid var(--border);
  padding: 0.5rem 1rem;
  border-radius: 0.5rem;
  font-size: 0.9rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.btn-outline:hover {
  background: var(--background);
  color: var(--dark);
}

.btn-primary {
  background: var(--accent);
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 0.5rem;
  font-size: 0.9rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.btn-primary:hover {
  background: #e04a4f;
  transform: translateY(-1px);
}
</style>
