<script setup lang="ts">
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'
</script>

<template>
  <div id="app" class="min-h-screen bg-background">
    <Header />
    
    <!-- Main Content -->
    <main>
      <router-view />
    </main>

    <Footer />
  </div>
</template>

<style>
/* Глобальные стили остаются в main.css */
</style>
