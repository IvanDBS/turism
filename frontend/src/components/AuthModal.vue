<template>
  <div class="fixed inset-0 z-50 overflow-y-auto">
    <div class="flex min-h-screen items-center justify-center p-4">
      <!-- Backdrop -->
      <div 
        class="fixed inset-0 bg-black bg-opacity-50 transition-opacity"
        @click="$emit('close')"
      ></div>

      <!-- Modal -->
      <div class="relative w-full max-w-md transform overflow-hidden rounded-2xl bg-white p-6 shadow-xl transition-all animate-scale-in">
        <!-- Close Button -->
        <button
          @click="$emit('close')"
          class="absolute top-4 right-4 text-gray-400 hover:text-gray-600 transition-colors"
        >
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>

        <!-- Header -->
        <div class="text-center mb-8">
          <h2 class="text-3xl font-bold text-gray-900 mb-2">
            {{ mode === 'login' ? 'Войти в аккаунт' : 'Создать аккаунт' }}
          </h2>
          <p class="text-gray-600">
            {{ mode === 'login' ? 'Войдите в свой аккаунт для доступа к турам' : 'Создайте аккаунт для бронирования туров' }}
          </p>
        </div>

        <!-- Form -->
        <form @submit.prevent="handleSubmit" class="space-y-6">
          <!-- Name field (only for register) -->
          <div v-if="mode === 'register'">
            <label for="name" class="block text-sm font-medium text-gray-700 mb-2">
              Имя
            </label>
            <input
              id="name"
              v-model="form.name"
              type="text"
              required
              class="input-field"
              placeholder="Введите ваше имя"
            />
          </div>

          <!-- Email field -->
          <div>
            <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
              Email
            </label>
            <input
              id="email"
              v-model="form.email"
              type="email"
              required
              class="input-field"
              placeholder="Введите ваш email"
            />
          </div>

          <!-- Password field -->
          <div>
            <label for="password" class="block text-sm font-medium text-gray-700 mb-2">
              Пароль
            </label>
            <input
              id="password"
              v-model="form.password"
              type="password"
              required
              class="input-field"
              placeholder="Введите пароль"
            />
          </div>

          <!-- Confirm Password field (only for register) -->
          <div v-if="mode === 'register'">
            <label for="password_confirmation" class="block text-sm font-medium text-gray-700 mb-2">
              Подтвердите пароль
            </label>
            <input
              id="password_confirmation"
              v-model="form.password_confirmation"
              type="password"
              required
              class="input-field"
              placeholder="Подтвердите пароль"
            />
          </div>

          <!-- Error Message -->
          <div v-if="error" class="text-red-500 text-sm text-center">
            {{ error }}
          </div>

          <!-- Submit Button -->
          <button
            type="submit"
            :disabled="loading"
            class="w-full btn-primary disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <span v-if="loading" class="flex items-center justify-center">
              <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              {{ mode === 'login' ? 'Вход...' : 'Регистрация...' }}
            </span>
            <span v-else>
              {{ mode === 'login' ? 'Войти' : 'Зарегистрироваться' }}
            </span>
          </button>
        </form>

        <!-- Switch Mode -->
        <div class="mt-6 text-center">
          <p class="text-gray-600">
            {{ mode === 'login' ? 'Нет аккаунта?' : 'Уже есть аккаунт?' }}
            <button
              @click="switchMode"
              class="text-primary-500 hover:text-primary-600 font-medium transition-colors"
            >
              {{ mode === 'login' ? 'Зарегистрироваться' : 'Войти' }}
            </button>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useAuthStore } from '@/stores/auth'

interface Props {
  mode: 'login' | 'register'
}

interface Emits {
  (e: 'close'): void
  (e: 'success'): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

const authStore = useAuthStore()
const loading = ref(false)
const error = ref('')

const form = reactive({
  name: '',
  email: '',
  password: '',
  password_confirmation: ''
})

const handleSubmit = async () => {
  loading.value = true
  error.value = ''

  try {
    if (props.mode === 'login') {
      await authStore.login(form.email, form.password)
    } else {
      await authStore.register({
        name: form.name,
        email: form.email,
        password: form.password,
        password_confirmation: form.password_confirmation
      })
    }
    
    emit('success')
  } catch (err: any) {
    if (err.response?.data?.error) {
      error.value = err.response.data.error
    } else if (err.response?.data?.errors) {
      error.value = Object.values(err.response.data.errors).flat().join(', ')
    } else {
      error.value = 'Произошла ошибка. Попробуйте еще раз.'
    }
  } finally {
    loading.value = false
  }
}

const switchMode = () => {
  // Reset form
  form.name = ''
  form.email = ''
  form.password = ''
  form.password_confirmation = ''
  error.value = ''
  
  // Emit event to parent to switch mode
  emit('close')
}
</script>
