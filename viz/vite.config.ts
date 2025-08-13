import { defineConfig } from 'vite';
import { resolve } from 'path';

export default defineConfig({
  root: '.',
  base: './',
  build: {
    target: 'es2020',
    outDir: 'dist',
    assetsDir: 'assets',
    sourcemap: true,
    minify: 'terser',
    terserOptions: {
      compress: {
        drop_console: true,
        drop_debugger: true,
        pure_funcs: ['console.log', 'console.info', 'console.debug'],
        passes: 2
      },
      mangle: {
        properties: false
      },
      format: {
        comments: false
      }
    },
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'index.html')
      },
      output: {
        manualChunks: {
          'math': ['./src/core/MathEngine.ts'],
          'renderer': ['./src/core/WebGLRenderer.ts'],
          'scenes': [
            './src/scenes/SimplexVisualization.ts',
            './src/scenes/PotionSimulation.ts',
            './src/scenes/PMFLandscape.ts',
            './src/scenes/TelescopingSeries.ts',
            './src/scenes/EmergenceVisualization.ts'
          ]
        }
      }
    },
    chunkSizeWarningLimit: 1000
  },
  server: {
    port: 3000,
    open: true,
    cors: true
  },
  preview: {
    port: 3001,
    open: true
  }
});