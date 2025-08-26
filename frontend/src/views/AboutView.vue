<template>
  <div class="about">
    <div class="container">
      <h1 class="page-title">О нас</h1>
      <div class="about-content">
        <div class="about-section">
          <h2>migo.md — ваш онлайн-помощник в путешествиях</h2>
          <p>
            Мы создали migo.md, чтобы изменить то, как люди планируют и бронируют свои путешествия. 
            Вместо того чтобы тратить часы на поиск туров, звонки в агентства и стояние в очередях, 
            мы предлагаем простой и удобный способ забронировать тур онлайн за несколько минут.
          </p>
        </div>
        
        <div class="about-section">
          <h3>Наша миссия</h3>
          <p>
            Сделать планирование отпуска простым, быстрым и приятным. Мы верим, что каждый заслуживает 
            отличного отдыха без лишних хлопот и стресса.
          </p>
        </div>
        
        <div class="about-section">
          <h3>Почему migo.md?</h3>
          <ul>
            <li>✅ Экономия времени — бронируйте за 2 минуты</li>
            <li>✅ Прозрачные цены — никаких скрытых комиссий</li>
            <li>✅ Удобство — всё из дома, в любое время</li>
            <li>✅ Надежность — проверенные предложения</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.about {
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

.about-content {
  display: flex;
  flex-direction: column;
  gap: 40px;
}

.about-section {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.about-section h2 {
  font-size: 1.8rem;
  font-weight: 600;
  color: var(--dark);
  margin: 0;
}

.about-section h3 {
  font-size: 1.4rem;
  font-weight: 600;
  color: var(--primary);
  margin: 0;
}

.about-section p {
  font-size: 1.1rem;
  line-height: 1.7;
  color: var(--secondary-text);
  margin: 0;
}

.about-section ul {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.about-section li {
  font-size: 1.1rem;
  color: var(--secondary-text);
  padding-left: 0;
}

@media (max-width: 768px) {
  .about {
    padding: 60px 20px;
  }
  
  .page-title {
    font-size: 2rem;
  }
  
  .about-section h2 {
    font-size: 1.5rem;
  }
}
</style>
