<template>
  <div class="contacts">
    <div class="container">
      <h1 class="page-title">Контакты</h1>
      
      <div class="contacts-content">
        <div class="contact-info">
          <h2>Свяжитесь с нами</h2>
          <p>У вас есть вопросы? Мы всегда готовы помочь!</p>
          
          <div class="contact-methods">
            <div class="contact-method">
              <div class="contact-icon">📞</div>
              <div class="contact-details">
                <h3>Телефон</h3>
                <p>+373 22 123 456</p>
                <p class="contact-note">Пн-Пт: 9:00-18:00</p>
              </div>
            </div>
            
            <div class="contact-method">
              <div class="contact-icon">📧</div>
              <div class="contact-details">
                <h3>Email</h3>
                <p>info@migo.md</p>
                <p class="contact-note">Ответим в течение 24 часов</p>
              </div>
            </div>
            
            <div class="contact-method">
              <div class="contact-icon">📍</div>
              <div class="contact-details">
                <h3>Адрес</h3>
                <p>ул. Штефан чел Маре, 123</p>
                <p>Кишинёв, Молдова</p>
              </div>
            </div>
          </div>
        </div>
        
        <div class="contact-form">
          <h2>Напишите нам</h2>
          <form @submit.prevent="submitForm">
            <div class="form-group">
              <label for="name">Имя *</label>
              <input 
                id="name"
                v-model="form.name"
                type="text" 
                required
                placeholder="Ваше имя"
              >
            </div>
            
            <div class="form-group">
              <label for="email">Email *</label>
              <input 
                id="email"
                v-model="form.email"
                type="email" 
                required
                placeholder="your@email.com"
              >
            </div>
            
            <div class="form-group">
              <label for="subject">Тема</label>
              <select id="subject" v-model="form.subject">
                <option value="">Выберите тему</option>
                <option value="booking">Бронирование тура</option>
                <option value="support">Техническая поддержка</option>
                <option value="partnership">Сотрудничество</option>
                <option value="other">Другое</option>
              </select>
            </div>
            
            <div class="form-group">
              <label for="message">Сообщение *</label>
              <textarea 
                id="message"
                v-model="form.message"
                rows="5"
                required
                placeholder="Опишите ваш вопрос или предложение..."
              ></textarea>
            </div>
            
            <button type="submit" class="submit-button">
              Отправить сообщение
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const form = ref({
  name: '',
  email: '',
  subject: '',
  message: ''
})

const submitForm = () => {
  console.log('Форма отправлена:', form.value)
  // Здесь будет логика отправки формы
  alert('Спасибо! Ваше сообщение отправлено.')
  
  // Очищаем форму
  form.value = {
    name: '',
    email: '',
    subject: '',
    message: ''
  }
}
</script>

<style scoped>
.contacts {
  padding: 80px 20px;
  background: white;
}

.container {
  max-width: 1000px;
  margin: 0 auto;
}

.page-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: var(--dark);
  text-align: center;
  margin-bottom: 60px;
}

.contacts-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 60px;
}

.contact-info h2,
.contact-form h2 {
  font-size: 1.8rem;
  font-weight: 600;
  color: var(--dark);
  margin: 0 0 20px 0;
}

.contact-info p {
  color: var(--secondary-text);
  font-size: 1.1rem;
  line-height: 1.6;
  margin: 0 0 40px 0;
}

.contact-methods {
  display: flex;
  flex-direction: column;
  gap: 30px;
}

.contact-method {
  display: flex;
  gap: 20px;
  align-items: flex-start;
}

.contact-icon {
  font-size: 2rem;
  width: 60px;
  height: 60px;
  background: var(--background);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.contact-details h3 {
  font-size: 1.2rem;
  font-weight: 600;
  color: var(--dark);
  margin: 0 0 8px 0;
}

.contact-details p {
  color: var(--secondary-text);
  margin: 0 0 4px 0;
  font-size: 1rem;
}

.contact-note {
  font-size: 0.9rem !important;
  color: #999 !important;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 20px;
}

.form-group label {
  font-weight: 600;
  color: var(--dark);
  font-size: 0.9rem;
}

.form-group input,
.form-group select,
.form-group textarea {
  padding: 12px;
  border: 1px solid var(--border);
  border-radius: 6px;
  font-size: 1rem;
  font-family: 'Onest', sans-serif;
  transition: border-color 0.2s ease;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  outline: none;
  border-color: var(--accent);
  box-shadow: 0 0 0 3px rgba(255, 90, 95, 0.08);
}

.form-group textarea {
  resize: vertical;
  min-height: 120px;
}

.submit-button {
  background: var(--accent);
  color: white;
  border: none;
  padding: 14px 28px;
  border-radius: 6px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  width: 100%;
}

.submit-button:hover {
  background: #e04a4f;
  transform: translateY(-1px);
}

@media (max-width: 768px) {
  .contacts {
    padding: 60px 20px;
  }
  
  .page-title {
    font-size: 2rem;
  }
  
  .contacts-content {
    grid-template-columns: 1fr;
    gap: 40px;
  }
  
  .contact-method {
    flex-direction: column;
    text-align: center;
  }
}
</style>
