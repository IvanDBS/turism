import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import axios from 'axios'

interface User {
  id: number
  email: string
  name: string
  role: string
}

interface AuthResponse {
  user: User
  token: string
}

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(null)
  const token = ref<string | null>(localStorage.getItem('token'))

  const isAuthenticated = computed(() => !!token.value && !!user.value)

  // Настройка axios с токеном
  if (token.value) {
    axios.defaults.headers.common['Authorization'] = `Bearer ${token.value}`
  }

  const login = async (email: string, password: string): Promise<AuthResponse> => {
    try {
      const response = await axios.post('http://localhost:3000/api/v1/auth/login', {
        email,
        password
      })
      
      const { user: userData, token: authToken } = response.data
      
      user.value = userData
      token.value = authToken
      
      localStorage.setItem('token', authToken)
      axios.defaults.headers.common['Authorization'] = `Bearer ${authToken}`
      
      return response.data
    } catch (error) {
      throw error
    }
  }

  const register = async (userData: { email: string; name: string; password: string; password_confirmation: string }): Promise<AuthResponse> => {
    try {
      const response = await axios.post('http://localhost:3000/api/v1/auth/register', {
        user: userData
      })
      
      const { user: newUser, token: authToken } = response.data
      
      user.value = newUser
      token.value = authToken
      
      localStorage.setItem('token', authToken)
      axios.defaults.headers.common['Authorization'] = `Bearer ${authToken}`
      
      return response.data
    } catch (error) {
      throw error
    }
  }

  const logout = () => {
    user.value = null
    token.value = null
    localStorage.removeItem('token')
    delete axios.defaults.headers.common['Authorization']
  }

  const fetchUser = async () => {
    if (!token.value) return
    
    try {
      const response = await axios.get('http://localhost:3000/api/v1/auth/me')
      user.value = response.data
    } catch (error) {
      logout()
    }
  }

  // Инициализация при загрузке
  if (token.value) {
    fetchUser()
  }

  return {
    user,
    token,
    isAuthenticated,
    login,
    register,
    logout,
    fetchUser
  }
})
