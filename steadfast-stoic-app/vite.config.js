import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  server: {
    proxy: {
      '/dhanSymbols': 'http://localhost:3000',
      '/flattradeSymbols': 'http://localhost:3000',
      '/flattradeApi': {
        target: 'https://authapi.flattrade.in',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/flattradeApi/, '')
      },
      // '/dhanApi': {
      //   target: 'https://authapi.flattrade.in',
      //   changeOrigin: true,
      //   rewrite: (path) => path.replace(/^\/dhanApi/, '')
      // }
    }
  }
})
