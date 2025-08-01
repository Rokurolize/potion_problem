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
          'math': ['./src/visualization/core/MathEngine.ts'],
          'renderer': ['./src/visualization/core/WebGLRenderer.ts'],
          'scenes': [
            './src/visualization/scenes/SimplexVisualization.ts',
            './src/visualization/scenes/PotionSimulation.ts',
            './src/visualization/scenes/PMFLandscape.ts',
            './src/visualization/scenes/TelescopingSeries.ts',
            './src/visualization/scenes/EmergenceVisualization.ts'
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