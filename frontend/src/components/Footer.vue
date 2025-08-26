<script setup lang="ts">
const currentYear = new Date().getFullYear()
</script>

<template>
  <footer class="footer">
    <div class="footer-container">
      <div class="footer-content">
        <!-- Logo and Description -->
        <div class="footer-section">
          <h3 class="footer-logo">migo.md</h3>
          <p class="footer-description">
            Онлайн-сервис бронирования туров. Простота, удобство, всё в одном месте.
          </p>
        </div>

        <!-- Quick Links -->
        <div class="footer-section">
          <h4 class="footer-title">Быстрые ссылки</h4>
          <ul class="footer-links">
            <li><router-link to="/" class="footer-link">Главная</router-link></li>
            <li><router-link to="/tours" class="footer-link">Направления</router-link></li>
            <li><router-link to="/about" class="footer-link">О нас</router-link></li>
            <li><router-link to="/contacts" class="footer-link">Контакты</router-link></li>
          </ul>
        </div>

        <!-- Support -->
        <div class="footer-section">
          <h4 class="footer-title">Поддержка</h4>
          <ul class="footer-links">
            <li><a href="#" class="footer-link">Помощь</a></li>
            <li><a href="#" class="footer-link">FAQ</a></li>
            <li><a href="#" class="footer-link">Условия использования</a></li>
            <li><a href="#" class="footer-link">Политика конфиденциальности</a></li>
          </ul>
        </div>

        <!-- Contact Info -->
        <div class="footer-section">
          <h4 class="footer-title">Контакты</h4>
          <div class="contact-info">
            <p>📞 +373 22 123 456</p>
            <p>📧 info@migo.md</p>
            <p>📍 Кишинёв, Молдова</p>
          </div>
        </div>
      </div>

      <!-- Bottom Bar -->
      <div class="footer-bottom">
        <p>&copy; {{ currentYear }} migo.md — Путешествуй легко. Все права защищены.</p>
      </div>
    </div>
  </footer>
</template>

<style scoped>
.footer {
  background: var(--dark);
  color: white;
  padding: 60px 0 20px;
  margin-top: 80px;
}

.footer-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.footer-content {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 40px;
  margin-bottom: 40px;
}

.footer-section {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.footer-logo {
  font-size: 24px;
  font-weight: 700;
  color: var(--accent);
  margin: 0;
}

.footer-description {
  color: #ccc;
  line-height: 1.6;
  margin: 0;
}

.footer-title {
  font-size: 18px;
  font-weight: 600;
  margin: 0;
  color: white;
}

.footer-links {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.footer-link {
  color: #ccc;
  text-decoration: none;
  transition: color 0.2s ease;
}

.footer-link:hover {
  color: var(--accent);
}

.contact-info {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.contact-info p {
  color: #ccc;
  margin: 0;
}

.footer-bottom {
  border-top: 1px solid #333;
  padding-top: 20px;
  text-align: center;
  color: #999;
}

@media (max-width: 768px) {
  .footer {
    padding: 40px 0 20px;
  }
  
  .footer-content {
    grid-template-columns: 1fr;
    gap: 30px;
  }
}
</style>
