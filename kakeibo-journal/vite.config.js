import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// Mobile-first PWA. Base is relative so the build works when served from a subpath.
export default defineConfig({
  base: './',
  plugins: [react()],
  server: { port: 5174, host: true },
})
