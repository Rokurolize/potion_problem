/**
 * Potion Simulation Visualization
 * 
 * Shows the Monte Carlo hitting time process where we repeatedly sample
 * uniform random values (potions) until their sum exceeds 1.
 * 
 * This directly visualizes the core problem: E[τ] = e
 */

import { WebGLRenderer } from '../core/WebGLRenderer';
import { MathEngine } from '../core/MathEngine';
import { mat4, vec3 } from '../math/LinearAlgebra';

interface Potion {
    id: number;
    value: number;
    position: vec3;
    velocity: vec3;
    scale: number;
    color: vec3;
    age: number;
    state: 'falling' | 'stacked' | 'fading';
    targetY: number;
}

interface Trial {
    potions: Potion[];
    sum: number;
    hittingTime: number;
    state: 'running' | 'complete' | 'fading';
    fadeProgress: number;
}

export class PotionSimulation {
    private renderer: WebGLRenderer;
    private mathEngine: MathEngine;
    
    // Simulation state
    private trials: Trial[] = [];
    private activeTrials: number = 0;
    private maxTrials: number = 5;
    private completedTrials: number = 0;
    private runningAverage: number = 0;
    
    // Rendering resources
    private potionVAO: WebGLVertexArrayObject | null = null;
    private instanceBuffer: WebGLBuffer | null = null;
    private maxInstances: number = 1000;
    
    // Animation parameters
    private time: number = 0;
    private spawnInterval: number = 0.5;
    private lastSpawnTime: number = 0;
    private simulationSpeed: number = 1.0;
    
    // Visual parameters
    private potionScale: number = 0.15;
    private stackSpacing: number = 0.18;
    private trialSpacing: number = 3.0;
    
    constructor(renderer: WebGLRenderer, mathEngine: MathEngine) {
        this.renderer = renderer;
        this.mathEngine = mathEngine;
        this.initialize();
    }
    
    private initialize(): void {
        this.createShaders();
        this.createGeometry();
        this.resetSimulation();
    }
    
    private createShaders(): void {
        const vertexShader = `#version 300 es
            precision highp float;
            
            // Per-vertex attributes
            layout(location = 0) in vec3 a_position;
            layout(location = 1) in vec3 a_normal;
            
            // Per-instance attributes
            layout(location = 2) in vec3 a_instancePosition;
            layout(location = 3) in float a_instanceScale;
            layout(location = 4) in vec3 a_instanceColor;
            layout(location = 5) in float a_instanceAlpha;
            
            // Uniforms
            uniform mat4 u_projection;
            uniform mat4 u_view;
            uniform float u_time;
            
            // Outputs
            out vec3 v_normal;
            out vec3 v_position;
            out vec3 v_color;
            out float v_alpha;
            
            void main() {
                // Apply instance transform
                vec3 position = a_position * a_instanceScale + a_instancePosition;
                
                // Add subtle animation
                position.x += sin(u_time * 2.0 + float(gl_InstanceID)) * 0.02;
                position.y += cos(u_time * 1.5 + float(gl_InstanceID) * 0.7) * 0.01;
                
                gl_Position = u_projection * u_view * vec4(position, 1.0);
                
                v_normal = a_normal;
                v_position = position;
                v_color = a_instanceColor;
                v_alpha = a_instanceAlpha;
            }
        `;
        
        const fragmentShader = `#version 300 es
            precision highp float;
            
            in vec3 v_normal;
            in vec3 v_position;
            in vec3 v_color;
            in float v_alpha;
            
            uniform vec3 u_lightDirection;
            uniform float u_time;
            
            out vec4 fragColor;
            
            void main() {
                // Normalize the normal
                vec3 normal = normalize(v_normal);
                
                // Basic lighting
                float NdotL = max(dot(normal, u_lightDirection), 0.0);
                float ambient = 0.3;
                float diffuse = 0.7 * NdotL;
                
                // Rim lighting for potion glow effect
                vec3 viewDir = normalize(-v_position);
                float rim = 1.0 - max(dot(viewDir, normal), 0.0);
                rim = smoothstep(0.6, 1.0, rim);
                
                // Combine lighting
                vec3 lighting = vec3(ambient + diffuse);
                vec3 finalColor = v_color * lighting + v_color * rim * 0.5;
                
                // Add subtle sparkle
                float sparkle = sin(u_time * 10.0 + v_position.y * 20.0) * 0.05 + 0.95;
                finalColor *= sparkle;
                
                fragColor = vec4(finalColor, v_alpha);
            }
        `;
        
        this.renderer.createProgram('potion', { vertex: vertexShader, fragment: fragmentShader });
    }
    
    private createGeometry(): void {
        const gl = this.renderer.getContext();
        
        // Create a simple potion bottle shape (cylinder with rounded bottom)
        const segments = 16;
        const vertices: number[] = [];
        const normals: number[] = [];
        const indices: number[] = [];
        
        // Generate cylinder body
        for (let i = 0; i <= segments; i++) {
            const angle = (i / segments) * Math.PI * 2;
            const x = Math.cos(angle);
            const z = Math.sin(angle);
            
            // Bottom rim
            vertices.push(x * 0.4, 0, z * 0.4);
            normals.push(x, 0, z);
            
            // Top rim
            vertices.push(x * 0.3, 1, z * 0.3);
            normals.push(x, 0, z);
        }
        
        // Generate indices for cylinder
        for (let i = 0; i < segments; i++) {
            const a = i * 2;
            const b = i * 2 + 1;
            const c = (i + 1) * 2;
            const d = (i + 1) * 2 + 1;
            
            indices.push(a, c, b, b, c, d);
        }
        
        // Add bottle neck
        const neckStart = vertices.length / 3;
        for (let i = 0; i <= segments; i++) {
            const angle = (i / segments) * Math.PI * 2;
            const x = Math.cos(angle);
            const z = Math.sin(angle);
            
            vertices.push(x * 0.3, 1, z * 0.3);
            normals.push(x, 0, z);
            
            vertices.push(x * 0.15, 1.3, z * 0.15);
            normals.push(x, 0, z);
        }
        
        // Generate indices for neck
        for (let i = 0; i < segments; i++) {
            const a = neckStart + i * 2;
            const b = neckStart + i * 2 + 1;
            const c = neckStart + (i + 1) * 2;
            const d = neckStart + (i + 1) * 2 + 1;
            
            indices.push(a, c, b, b, c, d);
        }
        
        // Create VAO
        this.potionVAO = this.renderer.createVertexArray('potionVAO');
        gl.bindVertexArray(this.potionVAO);
        
        // Create and bind vertex buffer
        const vertexBuffer = this.renderer.createBuffer('potionVertices');
        gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
        gl.vertexAttribPointer(0, 3, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(0);
        
        // Create and bind normal buffer
        const normalBuffer = this.renderer.createBuffer('potionNormals');
        gl.bindBuffer(gl.ARRAY_BUFFER, normalBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(normals), gl.STATIC_DRAW);
        gl.vertexAttribPointer(1, 3, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(1);
        
        // Create instance buffer
        this.instanceBuffer = this.renderer.createBuffer('potionInstances');
        gl.bindBuffer(gl.ARRAY_BUFFER, this.instanceBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, this.maxInstances * 10 * 4, gl.DYNAMIC_DRAW);
        
        // Setup instance attributes
        // Position (vec3)
        gl.vertexAttribPointer(2, 3, gl.FLOAT, false, 10 * 4, 0);
        gl.vertexAttribDivisor(2, 1);
        gl.enableVertexAttribArray(2);
        
        // Scale (float)
        gl.vertexAttribPointer(3, 1, gl.FLOAT, false, 10 * 4, 3 * 4);
        gl.vertexAttribDivisor(3, 1);
        gl.enableVertexAttribArray(3);
        
        // Color (vec3)
        gl.vertexAttribPointer(4, 3, gl.FLOAT, false, 10 * 4, 4 * 4);
        gl.vertexAttribDivisor(4, 1);
        gl.enableVertexAttribArray(4);
        
        // Alpha (float)
        gl.vertexAttribPointer(5, 1, gl.FLOAT, false, 10 * 4, 7 * 4);
        gl.vertexAttribDivisor(5, 1);
        gl.enableVertexAttribArray(5);
        
        // Create index buffer
        const indexBuffer = this.renderer.createBuffer('potionIndices', gl.ELEMENT_ARRAY_BUFFER);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
        gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(indices), gl.STATIC_DRAW);
        
        gl.bindVertexArray(null);
    }
    
    private resetSimulation(): void {
        this.trials = [];
        this.completedTrials = 0;
        this.runningAverage = 0;
        this.activeTrials = 0;
        this.lastSpawnTime = 0;
    }
    
    private spawnTrial(): void {
        if (this.activeTrials >= this.maxTrials) return;
        
        const trial: Trial = {
            potions: [],
            sum: 0,
            hittingTime: 0,
            state: 'running',
            fadeProgress: 0
        };
        
        this.trials.push(trial);
        this.activeTrials++;
    }
    
    private spawnPotion(trial: Trial, index: number): void {
        const value = Math.random();
        const trialIndex = this.trials.indexOf(trial);
        
        const potion: Potion = {
            id: Date.now() + Math.random(),
            value: value,
            position: [
                (trialIndex - (this.maxTrials - 1) / 2) * this.trialSpacing,
                8,
                0
            ],
            velocity: [0, -2, 0],
            scale: this.potionScale * (0.8 + value * 0.4),
            color: this.getColorForValue(value),
            age: 0,
            state: 'falling',
            targetY: index * this.stackSpacing
        };
        
        trial.potions.push(potion);
    }
    
    private getColorForValue(value: number): vec3 {
        // Gradient from blue (low) to red (high)
        const t = value;
        const r = 0.2 + t * 0.8;
        const g = 0.3 + (1 - Math.abs(t - 0.5) * 2) * 0.4;
        const b = 0.9 - t * 0.7;
        return [r, g, b];
    }
    
    update(deltaTime: number): void {
        this.time += deltaTime;
        const adjustedDelta = deltaTime * this.simulationSpeed;
        
        // Spawn new trials
        if (this.time - this.lastSpawnTime > this.spawnInterval / this.simulationSpeed) {
            if (this.activeTrials < this.maxTrials) {
                this.spawnTrial();
                this.lastSpawnTime = this.time;
            }
        }
        
        // Update trials
        for (let i = this.trials.length - 1; i >= 0; i--) {
            const trial = this.trials[i];
            
            if (trial.state === 'running') {
                // Check if we need a new potion
                const fallingPotions = trial.potions.filter(p => p.state === 'falling').length;
                if (fallingPotions === 0 && trial.sum < 1) {
                    this.spawnPotion(trial, trial.potions.length);
                }
                
                // Update potions
                for (const potion of trial.potions) {
                    potion.age += adjustedDelta;
                    
                    if (potion.state === 'falling') {
                        potion.position[1] += potion.velocity[1] * adjustedDelta;
                        
                        if (potion.position[1] <= potion.targetY) {
                            potion.position[1] = potion.targetY;
                            potion.state = 'stacked';
                            potion.velocity = [0, 0, 0];
                            
                            trial.sum += potion.value;
                            
                            // Check if we've hit the target
                            if (trial.sum >= 1) {
                                trial.hittingTime = trial.potions.length;
                                trial.state = 'complete';
                                this.completedTrials++;
                                
                                // Update running average
                                this.runningAverage = ((this.runningAverage * (this.completedTrials - 1)) + trial.hittingTime) / this.completedTrials;
                            }
                        }
                    }
                }
            } else if (trial.state === 'complete') {
                // Fade out completed trials
                trial.fadeProgress += adjustedDelta * 0.5;
                
                if (trial.fadeProgress >= 1) {
                    trial.state = 'fading';
                }
            } else if (trial.state === 'fading') {
                // Remove and replace with new trial
                this.trials.splice(i, 1);
                this.activeTrials--;
            }
        }
    }
    
    render(projection: mat4, view: mat4): void {
        const gl = this.renderer.getContext();
        
        // Collect all potions for instanced rendering
        const instanceData: number[] = [];
        
        for (const trial of this.trials) {
            for (const potion of trial.potions) {
                let alpha = 1.0;
                
                if (trial.state === 'complete') {
                    alpha = 1.0 - trial.fadeProgress;
                }
                
                // Add subtle animation to stacked potions
                let x = potion.position[0];
                let y = potion.position[1];
                
                if (potion.state === 'stacked') {
                    x += Math.sin(this.time * 2 + potion.id) * 0.02;
                    y += Math.cos(this.time * 1.5 + potion.id * 0.7) * 0.01;
                }
                
                instanceData.push(
                    x, y, potion.position[2],  // position
                    potion.scale,               // scale
                    ...potion.color,            // color
                    alpha, 0, 0                 // alpha + padding
                );
            }
        }
        
        if (instanceData.length === 0) return;
        
        // Update instance buffer
        gl.bindBuffer(gl.ARRAY_BUFFER, this.instanceBuffer);
        gl.bufferSubData(gl.ARRAY_BUFFER, 0, new Float32Array(instanceData));
        
        // Set up rendering
        this.renderer.useProgram('potion');
        this.renderer.bindVertexArray('potionVAO');
        
        // Set uniforms
        this.renderer.setUniform('u_projection', 'mat4', projection);
        this.renderer.setUniform('u_view', 'mat4', view);
        this.renderer.setUniform('u_time', '1f', this.time);
        this.renderer.setUniform('u_lightDirection', '3f', [0.5, 0.7, 0.3]);
        
        // Enable blending for transparency
        this.renderer.setState({ blending: true, depthWrite: false });
        
        // Draw all potions
        const instanceCount = instanceData.length / 10;
        gl.drawElementsInstanced(gl.TRIANGLES, 16 * 6 * 2, gl.UNSIGNED_SHORT, 0, instanceCount);
        
        // Restore state
        this.renderer.setState({ blending: false, depthWrite: true });
    }
    
    setSimulationSpeed(speed: number): void {
        this.simulationSpeed = Math.max(0.1, Math.min(5.0, speed));
    }
    
    reset(): void {
        this.resetSimulation();
    }
    
    getInfo(): any {
        return {
            activeTrials: this.activeTrials,
            completedTrials: this.completedTrials,
            runningAverage: this.runningAverage,
            theoreticalExpected: Math.E,
            convergence: this.completedTrials > 0 ? Math.abs(this.runningAverage - Math.E) / Math.E : 1
        };
    }
}