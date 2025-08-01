/**
 * Main Application Entry Point
 * 
 * This is the orchestrator that brings together all visualization components
 * into a cohesive, interactive experience showcasing E[τ] = e
 */

import { WebGLRenderer } from './core/WebGLRenderer';
import { MathEngine } from './core/MathEngine';
import { SimplexVisualization } from './scenes/SimplexVisualization';
import { PotionSimulation } from './scenes/PotionSimulation';
import { PMFLandscape } from './scenes/PMFLandscape';
import { TelescopingSeries } from './scenes/TelescopingSeries';
import { EmergenceVisualization } from './scenes/EmergenceVisualization';
import { mat4, vec3 } from './math/LinearAlgebra';

// Visualization interfaces
interface Visualization {
    update(deltaTime: number): void;
    render(projection: mat4, view: mat4): void;
    handleInteraction?(event: InteractionEvent): void;
    getInfo?(): any;
}

interface InteractionEvent {
    type: 'click' | 'drag' | 'wheel' | 'touch';
    x: number;
    y: number;
    deltaX?: number;
    deltaY?: number;
    deltaZ?: number;
}

interface Camera {
    position: vec3;
    target: vec3;
    up: vec3;
    fov: number;
    near: number;
    far: number;
    distance: number;
    rotation: { x: number; y: number };
}

export class Application {
    private canvas: HTMLCanvasElement;
    private renderer: WebGLRenderer;
    private mathEngine: MathEngine;
    
    private visualizations: Map<string, Visualization>;
    private currentVisualization: Visualization | null = null;
    private currentVisualizationType: string = 'potion';
    
    private camera: Camera;
    private projectionMatrix: mat4;
    private viewMatrix: mat4;
    
    private lastTime: number = 0;
    private frameCount: number = 0;
    private fpsUpdateTime: number = 0;
    
    // Interaction state
    private mouse = {
        x: 0,
        y: 0,
        lastX: 0,
        lastY: 0,
        down: false,
        button: -1
    };
    
    private touch = {
        active: false,
        startX: 0,
        startY: 0,
        lastDistance: 0
    };
    
    constructor() {
        this.canvas = document.getElementById('canvas') as HTMLCanvasElement;
        if (!this.canvas) {
            throw new Error('Canvas element not found');
        }
        
        // Initialize core systems
        this.mathEngine = new MathEngine();
        this.renderer = new WebGLRenderer(this.canvas);
        
        // Initialize camera
        this.camera = {
            position: [0, 3, 8],
            target: [0, 0, 0],
            up: [0, 1, 0],
            fov: 50,
            near: 0.1,
            far: 100,
            distance: 8,
            rotation: { x: -0.3, y: 0 }
        };
        
        this.projectionMatrix = mat4.create();
        this.viewMatrix = mat4.create();
        
        this.visualizations = new Map();
        
        this.initialize();
    }
    
    private async initialize(): Promise<void> {
        try {
            // Initialize visualizations
            this.initializeVisualizations();
            
            // Setup UI
            this.setupUI();
            
            // Setup interactions
            this.setupInteractions();
            
            // Hide loading screen
            const loadingScreen = document.getElementById('loading');
            if (loadingScreen) {
                loadingScreen.classList.add('hidden');
                setTimeout(() => loadingScreen.remove(), 500);
            }
            
            // Start render loop
            this.animate();
            
        } catch (error) {
            console.error('Failed to initialize application:', error);
            this.showError('Failed to initialize WebGL. Please ensure you have a modern browser with WebGL2 support.');
        }
    }
    
    private initializeVisualizations(): void {
        // Create all visualization instances
        const potionSim = new PotionSimulation(this.renderer, this.mathEngine);
        this.visualizations.set('potion', potionSim);
        
        const simplexViz = new SimplexVisualization(this.renderer, this.mathEngine);
        this.visualizations.set('simplex', simplexViz);
        
        const pmfLandscape = new PMFLandscape(this.renderer, this.mathEngine);
        this.visualizations.set('pmf', pmfLandscape);
        
        const telescopingSeries = new TelescopingSeries(this.renderer, this.mathEngine);
        this.visualizations.set('telescoping', telescopingSeries);
        
        const emergenceViz = new EmergenceVisualization(this.renderer, this.mathEngine);
        this.visualizations.set('emergence', emergenceViz);
        
        // Start with potion simulation as default
        this.currentVisualization = potionSim;
        this.currentVisualizationType = 'potion';
        this.updateVisualizationInfo();
    }
    
    private setupUI(): void {
        // Visualization selector buttons
        const buttons = document.querySelectorAll('.viz-button');
        buttons.forEach(button => {
            button.addEventListener('click', (e) => {
                const target = e.currentTarget as HTMLElement;
                const vizType = target.dataset.viz;
                if (vizType) {
                    this.switchVisualization(vizType);
                }
            });
        });
        
        // Mobile UI toggle
        const uiToggle = document.getElementById('ui-toggle');
        const uiPanel = document.getElementById('ui-panel');
        if (uiToggle && uiPanel) {
            uiToggle.addEventListener('click', () => {
                uiPanel.classList.toggle('hidden');
            });
        }
        
        // Create controls based on current visualization
        this.createControls();
    }
    
    private setupInteractions(): void {
        // Mouse interactions
        this.canvas.addEventListener('mousedown', this.onMouseDown.bind(this));
        this.canvas.addEventListener('mousemove', this.onMouseMove.bind(this));
        this.canvas.addEventListener('mouseup', this.onMouseUp.bind(this));
        this.canvas.addEventListener('wheel', this.onWheel.bind(this), { passive: false });
        
        // Touch interactions
        this.canvas.addEventListener('touchstart', this.onTouchStart.bind(this), { passive: false });
        this.canvas.addEventListener('touchmove', this.onTouchMove.bind(this), { passive: false });
        this.canvas.addEventListener('touchend', this.onTouchEnd.bind(this), { passive: false });
        
        // Keyboard shortcuts
        window.addEventListener('keydown', this.onKeyDown.bind(this));
        
        // Window resize
        window.addEventListener('resize', this.onResize.bind(this));
    }
    
    private switchVisualization(type: string): void {
        const viz = this.visualizations.get(type);
        if (!viz) {
            console.warn(`Visualization '${type}' not implemented yet`);
            return;
        }
        
        this.currentVisualization = viz;
        this.currentVisualizationType = type;
        
        // Update UI
        const buttons = document.querySelectorAll('.viz-button');
        buttons.forEach(button => {
            button.classList.toggle('active', button.dataset.viz === type);
        });
        
        // Update info and controls
        this.updateVisualizationInfo();
        this.createControls();
        
        // Reset camera for different visualizations
        this.resetCamera(type);
    }
    
    private updateVisualizationInfo(): void {
        const infoContainer = document.getElementById('viz-info');
        if (!infoContainer || !this.currentVisualization) return;
        
        let infoHTML = '';
        
        if (this.currentVisualizationType === 'potion' && this.currentVisualization.getInfo) {
            const info = this.currentVisualization.getInfo();
            const convergencePercent = (info.convergence * 100).toFixed(2);
            const averageFormatted = info.runningAverage.toFixed(6);
            const expectedFormatted = info.theoreticalExpected.toFixed(6);
            
            infoHTML = `
                <div class="info-section">
                    <div class="info-label">Completed Trials</div>
                    <div class="info-value">${info.completedTrials}</div>
                </div>
                <div class="info-section">
                    <div class="info-label">Running Average E[τ]</div>
                    <div class="info-value">${averageFormatted}</div>
                </div>
                <div class="info-section">
                    <div class="info-label">Theoretical E[τ]</div>
                    <div class="info-value">${expectedFormatted}</div>
                    <div class="formula">e = ${Math.E.toFixed(10)}...</div>
                </div>
                <div class="info-section">
                    <div class="info-label">Convergence Error</div>
                    <div class="info-value" style="color: ${info.convergence < 0.05 ? 'var(--accent-green)' : 'var(--accent-orange)'}">
                        ${convergencePercent}%
                    </div>
                </div>
            `;
        } else if (this.currentVisualizationType === 'simplex' && this.currentVisualization.getInfo) {
            const info = this.currentVisualization.getInfo();
            infoHTML = `
                <div class="info-section">
                    <div class="info-label">Dimension</div>
                    <div class="info-value">n = ${info.dimension}</div>
                </div>
                <div class="info-section">
                    <div class="info-label">Simplex Volume</div>
                    <div class="info-value">${info.volume.toExponential(4)}</div>
                    <div class="formula">${info.formula}</div>
                </div>
                <div class="info-section">
                    <div class="info-label">Connection to P(τ > n)</div>
                    <div class="formula">P(τ > n) = Vol(Δ_n) = 1/n!</div>
                </div>
            `;
        } else if (this.currentVisualizationType === 'pmf' && this.currentVisualization.getInfo) {
            const info = this.currentVisualization.getInfo();
            infoHTML = `
                <div class="info-section">
                    <div class="info-label">View Mode</div>
                    <div class="info-value" style="text-transform: capitalize">${info.viewMode}</div>
                </div>
                <div class="info-section">
                    <div class="info-label">Maximum P(τ = n)</div>
                    <div class="info-value">${info.maxProbability.toFixed(4)}</div>
                    <div class="formula">at n = ${info.modeValue}</div>
                </div>
                <div class="info-section">
                    <div class="info-label">PMF Formula</div>
                    <div class="formula">P(τ = n) = (n-1)/n!</div>
                </div>
                <div class="info-section">
                    <div class="info-label">Expected Value</div>
                    <div class="formula">E[τ] = Σ n·P(τ = n) = e</div>
                </div>
            `;
        } else if (this.currentVisualizationType === 'telescoping' && this.currentVisualization.getInfo) {
            const info = this.currentVisualization.getInfo();
            infoHTML = `
                <div class="info-section">
                    <div class="info-label">Step ${info.currentStep} of ${info.totalSteps}</div>
                    <div class="info-value">${info.description}</div>
                </div>
                <div class="info-section">
                    <div class="formula">${info.formula}</div>
                </div>
                <div class="info-section">
                    <div class="info-label">Partial Sum</div>
                    <div class="info-value">${info.partialSum.toFixed(8)}</div>
                </div>
                <div class="info-section">
                    <div class="info-label">Status</div>
                    <div class="info-value">
                        ${info.paused ? '⏸ Paused' : '▶ Playing'}
                        ${info.autoAdvance ? '(Auto)' : '(Manual)'}
                    </div>
                </div>
            `;
        } else if (this.currentVisualizationType === 'emergence' && this.currentVisualization.getInfo) {
            const info = this.currentVisualization.getInfo();
            const convergenceBar = '█'.repeat(Math.floor(info.convergenceProgress * 20)) + 
                                   '░'.repeat(20 - Math.floor(info.convergenceProgress * 20));
            
            infoHTML = `
                <div class="info-section">
                    <div class="info-label">Monte Carlo Trials</div>
                    <div class="info-value">${info.trials.toLocaleString()}</div>
                </div>
                <div class="info-section">
                    <div class="info-label">Current Average</div>
                    <div class="info-value">${info.runningAverage.toFixed(8)}</div>
                    <div class="formula">Target: e = ${info.theoreticalValue.toFixed(8)}</div>
                </div>
                <div class="info-section">
                    <div class="info-label">Error</div>
                    <div class="info-value" style="color: ${parseFloat(info.errorPercent) < 1 ? 'var(--accent-green)' : 'var(--accent-orange)'}">
                        ${info.errorPercent}%
                    </div>
                </div>
                <div class="info-section">
                    <div class="info-label">Convergence</div>
                    <div style="font-family: monospace; color: var(--accent-blue);">
                        ${convergenceBar}
                    </div>
                </div>
            `;
        }
        
        infoContainer.innerHTML = infoHTML;
    }
    
    private createControls(): void {
        const controlsContainer = document.getElementById('controls');
        if (!controlsContainer) return;
        
        let controlsHTML = '';
        
        if (this.currentVisualizationType === 'potion') {
            controlsHTML = `
                <div class="control-group">
                    <label class="control-label">Simulation Speed</label>
                    <input type="range" class="slider" id="speed-slider" 
                           min="0.1" max="5" value="1" step="0.1">
                    <div style="display: flex; justify-content: space-between; margin-top: 4px;">
                        <span style="font-size: 0.8em; opacity: 0.6;">0.1x</span>
                        <span style="font-size: 0.8em; opacity: 0.6;">5x</span>
                    </div>
                </div>
                <div class="control-group" style="margin-top: 16px;">
                    <button id="reset-button" style="
                        width: 100%;
                        padding: 12px;
                        background: rgba(255, 255, 255, 0.1);
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        color: var(--text-primary);
                        border-radius: 8px;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        font-size: 0.9em;
                    " onmouseover="this.style.background='rgba(255, 255, 255, 0.15)'" 
                       onmouseout="this.style.background='rgba(255, 255, 255, 0.1)'">
                        Reset Simulation
                    </button>
                </div>
            `;
        } else if (this.currentVisualizationType === 'simplex') {
            controlsHTML = `
                <div class="control-group">
                    <label class="control-label">Dimension (n)</label>
                    <input type="range" class="slider" id="dimension-slider" 
                           min="1" max="10" value="3" step="1">
                    <div style="display: flex; justify-content: space-between; margin-top: 4px;">
                        <span style="font-size: 0.8em; opacity: 0.6;">1</span>
                        <span style="font-size: 0.8em; opacity: 0.6;">10</span>
                    </div>
                </div>
            `;
        } else if (this.currentVisualizationType === 'pmf') {
            controlsHTML = `
                <div class="control-group">
                    <label class="control-label">View Mode</label>
                    <select id="view-mode-select" style="
                        width: 100%;
                        padding: 8px;
                        background: rgba(255, 255, 255, 0.1);
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        color: var(--text-primary);
                        border-radius: 4px;
                        font-size: 0.9em;
                        cursor: pointer;
                    ">
                        <option value="surface">Surface Plot</option>
                        <option value="bars">Bar Chart</option>
                        <option value="contour">Contour Map</option>
                        <option value="heatmap">Heat Map</option>
                    </select>
                </div>
                <div class="control-group" style="margin-top: 16px;">
                    <label class="control-label">Height Scale</label>
                    <input type="range" class="slider" id="height-scale-slider" 
                           min="1" max="20" value="10" step="0.5">
                    <div style="display: flex; justify-content: space-between; margin-top: 4px;">
                        <span style="font-size: 0.8em; opacity: 0.6;">1x</span>
                        <span style="font-size: 0.8em; opacity: 0.6;">20x</span>
                    </div>
                </div>
            `;
        } else if (this.currentVisualizationType === 'telescoping') {
            controlsHTML = `
                <div class="control-group" style="display: flex; gap: 8px;">
                    <button id="prev-step-button" style="
                        flex: 1;
                        padding: 10px;
                        background: rgba(255, 255, 255, 0.1);
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        color: var(--text-primary);
                        border-radius: 4px;
                        cursor: pointer;
                        font-size: 0.9em;
                    ">← Previous</button>
                    <button id="play-pause-button" style="
                        flex: 1;
                        padding: 10px;
                        background: rgba(255, 255, 255, 0.1);
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        color: var(--text-primary);
                        border-radius: 4px;
                        cursor: pointer;
                        font-size: 0.9em;
                    ">⏸ Pause</button>
                    <button id="next-step-button" style="
                        flex: 1;
                        padding: 10px;
                        background: rgba(255, 255, 255, 0.1);
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        color: var(--text-primary);
                        border-radius: 4px;
                        cursor: pointer;
                        font-size: 0.9em;
                    ">Next →</button>
                </div>
                <div class="control-group" style="margin-top: 16px;">
                    <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                        <input type="checkbox" id="auto-advance-checkbox" checked style="cursor: pointer;">
                        <span style="font-size: 0.9em;">Auto-advance steps</span>
                    </label>
                </div>
            `;
        } else if (this.currentVisualizationType === 'emergence') {
            controlsHTML = `
                <div class="control-group">
                    <label class="control-label">Display Mode</label>
                    <select id="display-mode-select" style="
                        width: 100%;
                        padding: 8px;
                        background: rgba(255, 255, 255, 0.1);
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        color: var(--text-primary);
                        border-radius: 4px;
                        font-size: 0.9em;
                        cursor: pointer;
                    ">
                        <option value="unified">Unified View</option>
                        <option value="split">Split View</option>
                        <option value="focus">Focus Mode</option>
                    </select>
                </div>
                <div class="control-group" style="margin-top: 16px;">
                    <button id="reset-emergence-button" style="
                        width: 100%;
                        padding: 12px;
                        background: rgba(255, 255, 255, 0.1);
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        color: var(--text-primary);
                        border-radius: 8px;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        font-size: 0.9em;
                    " onmouseover="this.style.background='rgba(255, 255, 255, 0.15)'" 
                       onmouseout="this.style.background='rgba(255, 255, 255, 0.1)'">
                        Reset Convergence
                    </button>
                </div>
            `;
        }
        
        controlsContainer.innerHTML = controlsHTML;
        
        // Add event listeners to controls
        if (this.currentVisualizationType === 'potion') {
            const speedSlider = document.getElementById('speed-slider') as HTMLInputElement;
            if (speedSlider) {
                speedSlider.addEventListener('input', (e) => {
                    const value = parseFloat((e.target as HTMLInputElement).value);
                    const viz = this.currentVisualization as PotionSimulation;
                    viz.setSimulationSpeed(value);
                });
            }
            
            const resetButton = document.getElementById('reset-button');
            if (resetButton) {
                resetButton.addEventListener('click', () => {
                    const viz = this.currentVisualization as PotionSimulation;
                    viz.reset();
                    this.updateVisualizationInfo();
                });
            }
        } else if (this.currentVisualizationType === 'simplex') {
            const slider = document.getElementById('dimension-slider') as HTMLInputElement;
            if (slider) {
                slider.addEventListener('input', (e) => {
                    const value = parseInt((e.target as HTMLInputElement).value);
                    const viz = this.currentVisualization as SimplexVisualization;
                    viz.setDimension(value);
                    this.updateVisualizationInfo();
                });
            }
        } else if (this.currentVisualizationType === 'pmf') {
            const viewModeSelect = document.getElementById('view-mode-select') as HTMLSelectElement;
            if (viewModeSelect) {
                viewModeSelect.addEventListener('change', (e) => {
                    const value = (e.target as HTMLSelectElement).value as any;
                    const viz = this.currentVisualization as PMFLandscape;
                    viz.setViewMode(value);
                    this.updateVisualizationInfo();
                });
            }
            
            const heightScaleSlider = document.getElementById('height-scale-slider') as HTMLInputElement;
            if (heightScaleSlider) {
                heightScaleSlider.addEventListener('input', (e) => {
                    const value = parseFloat((e.target as HTMLInputElement).value);
                    const viz = this.currentVisualization as PMFLandscape;
                    viz.setHeightScale(value);
                    this.updateVisualizationInfo();
                });
            }
        } else if (this.currentVisualizationType === 'telescoping') {
            const viz = this.currentVisualization as TelescopingSeries;
            
            const prevButton = document.getElementById('prev-step-button');
            if (prevButton) {
                prevButton.addEventListener('click', () => {
                    viz.previousStep();
                    this.updateVisualizationInfo();
                });
            }
            
            const playPauseButton = document.getElementById('play-pause-button');
            if (playPauseButton) {
                playPauseButton.addEventListener('click', () => {
                    const info = viz.getInfo();
                    viz.setPaused(!info.paused);
                    playPauseButton.textContent = info.paused ? '▶ Play' : '⏸ Pause';
                    this.updateVisualizationInfo();
                });
            }
            
            const nextButton = document.getElementById('next-step-button');
            if (nextButton) {
                nextButton.addEventListener('click', () => {
                    viz.nextStep();
                    this.updateVisualizationInfo();
                });
            }
            
            const autoAdvanceCheckbox = document.getElementById('auto-advance-checkbox') as HTMLInputElement;
            if (autoAdvanceCheckbox) {
                autoAdvanceCheckbox.addEventListener('change', (e) => {
                    viz.setAutoAdvance((e.target as HTMLInputElement).checked);
                    this.updateVisualizationInfo();
                });
            }
        } else if (this.currentVisualizationType === 'emergence') {
            const viz = this.currentVisualization as EmergenceVisualization;
            
            const displayModeSelect = document.getElementById('display-mode-select') as HTMLSelectElement;
            if (displayModeSelect) {
                displayModeSelect.addEventListener('change', (e) => {
                    const value = (e.target as HTMLSelectElement).value as any;
                    viz.setDisplayMode(value);
                    this.updateVisualizationInfo();
                });
            }
            
            const resetButton = document.getElementById('reset-emergence-button');
            if (resetButton) {
                resetButton.addEventListener('click', () => {
                    viz.reset();
                    this.updateVisualizationInfo();
                });
            }
        }
    }
    
    private resetCamera(vizType: string): void {
        // Different camera positions for different visualizations
        switch (vizType) {
            case 'simplex':
                this.camera.distance = 5;
                this.camera.rotation = { x: -0.3, y: 0 };
                break;
            case 'potion':
                this.camera.distance = 10;
                this.camera.rotation = { x: -0.2, y: 0 };
                break;
            case 'pmf':
                this.camera.distance = 15;
                this.camera.rotation = { x: -0.5, y: 0.2 };
                break;
            case 'telescoping':
                this.camera.distance = 12;
                this.camera.rotation = { x: -0.1, y: 0 };
                break;
            case 'emergence':
                this.camera.distance = 10;
                this.camera.rotation = { x: -0.15, y: 0 };
                break;
            default:
                this.camera.distance = 8;
                this.camera.rotation = { x: -0.3, y: 0 };
        }
    }
    
    private updateCamera(): void {
        // Update camera position based on rotation and distance
        const rotX = this.camera.rotation.x;
        const rotY = this.camera.rotation.y;
        
        this.camera.position[0] = Math.sin(rotY) * Math.cos(rotX) * this.camera.distance;
        this.camera.position[1] = Math.sin(rotX) * this.camera.distance + 2;
        this.camera.position[2] = Math.cos(rotY) * Math.cos(rotX) * this.camera.distance;
        
        // Update view matrix
        mat4.lookAt(this.viewMatrix, this.camera.position, this.camera.target, this.camera.up);
        
        // Update projection matrix
        const aspect = this.canvas.width / this.canvas.height;
        const fovRad = this.camera.fov * Math.PI / 180;
        mat4.perspective(this.projectionMatrix, fovRad, aspect, this.camera.near, this.camera.far);
    }
    
    private animate(): void {
        const currentTime = performance.now();
        const deltaTime = Math.min((currentTime - this.lastTime) / 1000, 0.1); // Cap at 100ms
        this.lastTime = currentTime;
        
        // Update
        this.updateCamera();
        if (this.currentVisualization) {
            this.currentVisualization.update(deltaTime);
            
            // Update info display periodically (4 times per second)
            if (currentTime - this.fpsUpdateTime > 250) {
                this.updateVisualizationInfo();
            }
        }
        
        // Render
        this.renderer.clear();
        if (this.currentVisualization) {
            this.currentVisualization.render(this.projectionMatrix, this.viewMatrix);
        }
        
        // Update stats
        this.updateStats();
        
        requestAnimationFrame(() => this.animate());
    }
    
    private updateStats(): void {
        this.frameCount++;
        
        const currentTime = performance.now();
        if (currentTime - this.fpsUpdateTime > 250) { // Update 4 times per second
            const stats = this.renderer.getStats();
            
            const fpsElement = document.getElementById('fps');
            const drawCallsElement = document.getElementById('draw-calls');
            const trianglesElement = document.getElementById('triangles');
            
            if (fpsElement) fpsElement.textContent = stats.fps.toString();
            if (drawCallsElement) drawCallsElement.textContent = stats.drawCalls.toString();
            if (trianglesElement) trianglesElement.textContent = stats.triangles.toLocaleString();
            
            this.frameCount = 0;
            this.fpsUpdateTime = currentTime;
        }
    }
    
    // Event handlers
    private onMouseDown(e: MouseEvent): void {
        this.mouse.down = true;
        this.mouse.button = e.button;
        this.mouse.x = e.clientX;
        this.mouse.y = e.clientY;
        this.mouse.lastX = e.clientX;
        this.mouse.lastY = e.clientY;
    }
    
    private onMouseMove(e: MouseEvent): void {
        if (!this.mouse.down) return;
        
        const deltaX = e.clientX - this.mouse.lastX;
        const deltaY = e.clientY - this.mouse.lastY;
        
        if (this.mouse.button === 0) { // Left click - rotate
            this.camera.rotation.y += deltaX * 0.01;
            this.camera.rotation.x += deltaY * 0.01;
            this.camera.rotation.x = Math.max(-Math.PI / 2, Math.min(Math.PI / 2, this.camera.rotation.x));
        }
        
        this.mouse.lastX = e.clientX;
        this.mouse.lastY = e.clientY;
    }
    
    private onMouseUp(e: MouseEvent): void {
        this.mouse.down = false;
        this.mouse.button = -1;
    }
    
    private onWheel(e: WheelEvent): void {
        e.preventDefault();
        
        const delta = e.deltaY * 0.001;
        this.camera.distance = Math.max(2, Math.min(50, this.camera.distance + delta * this.camera.distance * 0.1));
    }
    
    private onTouchStart(e: TouchEvent): void {
        e.preventDefault();
        
        if (e.touches.length === 1) {
            this.touch.active = true;
            this.touch.startX = e.touches[0].clientX;
            this.touch.startY = e.touches[0].clientY;
        } else if (e.touches.length === 2) {
            const dx = e.touches[1].clientX - e.touches[0].clientX;
            const dy = e.touches[1].clientY - e.touches[0].clientY;
            this.touch.lastDistance = Math.sqrt(dx * dx + dy * dy);
        }
    }
    
    private onTouchMove(e: TouchEvent): void {
        e.preventDefault();
        
        if (e.touches.length === 1 && this.touch.active) {
            const deltaX = e.touches[0].clientX - this.touch.startX;
            const deltaY = e.touches[0].clientY - this.touch.startY;
            
            this.camera.rotation.y += deltaX * 0.01;
            this.camera.rotation.x += deltaY * 0.01;
            this.camera.rotation.x = Math.max(-Math.PI / 2, Math.min(Math.PI / 2, this.camera.rotation.x));
            
            this.touch.startX = e.touches[0].clientX;
            this.touch.startY = e.touches[0].clientY;
        } else if (e.touches.length === 2) {
            const dx = e.touches[1].clientX - e.touches[0].clientX;
            const dy = e.touches[1].clientY - e.touches[0].clientY;
            const distance = Math.sqrt(dx * dx + dy * dy);
            
            if (this.touch.lastDistance > 0) {
                const scale = distance / this.touch.lastDistance;
                this.camera.distance /= scale;
                this.camera.distance = Math.max(2, Math.min(50, this.camera.distance));
            }
            
            this.touch.lastDistance = distance;
        }
    }
    
    private onTouchEnd(e: TouchEvent): void {
        e.preventDefault();
        this.touch.active = false;
        this.touch.lastDistance = 0;
    }
    
    private onKeyDown(e: KeyboardEvent): void {
        // Number keys switch visualizations
        if (e.key >= '1' && e.key <= '5') {
            const vizTypes = ['potion', 'simplex', 'pmf', 'telescoping', 'emergence'];
            const index = parseInt(e.key) - 1;
            if (index < vizTypes.length) {
                this.switchVisualization(vizTypes[index]);
            }
        }
        
        // Space resets camera
        if (e.key === ' ') {
            e.preventDefault();
            this.resetCamera(this.currentVisualizationType);
        }
    }
    
    private onResize(): void {
        this.renderer.resize();
    }
    
    private showError(message: string): void {
        const loadingScreen = document.getElementById('loading');
        if (loadingScreen) {
            loadingScreen.innerHTML = `
                <div class="loading-content">
                    <h1 class="loading-title">Error</h1>
                    <p class="loading-subtitle">${message}</p>
                </div>
            `;
        }
    }
}

// Initialize application when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => new Application());
} else {
    new Application();
}