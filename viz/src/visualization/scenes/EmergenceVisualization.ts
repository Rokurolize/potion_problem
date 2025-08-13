/**
 * The Emergence of e Visualization
 * 
 * A grand finale showing how e emerges from randomness through multiple
 * perspectives: Monte Carlo convergence, series summation, and geometric interpretation.
 */

import { WebGLRenderer } from '../core/WebGLRenderer';
import { MathEngine } from '../core/MathEngine';
import { mat4, vec3 } from '../math/LinearAlgebra';

interface DataPoint {
    x: number;
    y: number;
    value: number;
    age: number;
}

interface Particle {
    position: vec3;
    velocity: vec3;
    life: number;
    color: vec3;
    size: number;
}

export class EmergenceVisualization {
    private renderer: WebGLRenderer;
    private mathEngine: MathEngine;
    
    // Simulation data
    private trials: number = 0;
    private runningAverage: number = 0;
    private convergenceHistory: DataPoint[] = [];
    private seriesTerms: number[] = [];
    private partialSums: number[] = [];
    
    // Visual elements
    private particles: Particle[] = [];
    private maxParticles: number = 1000;
    private spiralPhase: number = 0;
    
    // Animation state
    private time: number = 0;
    private convergenceProgress: number = 0;
    private displayMode: 'unified' | 'split' | 'focus' = 'unified';
    
    // Rendering resources
    private particleVAO: WebGLVertexArrayObject | null = null;
    private graphVAO: WebGLVertexArrayObject | null = null;
    private textVAO: WebGLVertexArrayObject | null = null;
    
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
        // Particle shader for the swirling e visualization
        const particleVertexShader = `#version 300 es
            precision highp float;
            
            layout(location = 0) in vec2 a_position;
            
            // Instance attributes
            layout(location = 1) in vec3 a_instancePosition;
            layout(location = 2) in vec3 a_instanceVelocity;
            layout(location = 3) in float a_instanceLife;
            layout(location = 4) in vec3 a_instanceColor;
            layout(location = 5) in float a_instanceSize;
            
            uniform mat4 u_projection;
            uniform mat4 u_view;
            uniform float u_time;
            
            out vec3 v_color;
            out float v_life;
            out vec2 v_uv;
            
            void main() {
                // Billboard calculation
                vec3 cameraRight = vec3(u_view[0][0], u_view[1][0], u_view[2][0]);
                vec3 cameraUp = vec3(u_view[0][1], u_view[1][1], u_view[2][1]);
                
                vec3 position = a_instancePosition + 
                    cameraRight * a_position.x * a_instanceSize + 
                    cameraUp * a_position.y * a_instanceSize;
                
                gl_Position = u_projection * u_view * vec4(position, 1.0);
                
                v_color = a_instanceColor;
                v_life = a_instanceLife;
                v_uv = a_position + 0.5;
            }
        `;
        
        const particleFragmentShader = `#version 300 es
            precision highp float;
            
            in vec3 v_color;
            in float v_life;
            in vec2 v_uv;
            
            out vec4 fragColor;
            
            void main() {
                // Soft circular particle
                float dist = length(v_uv - 0.5) * 2.0;
                float alpha = 1.0 - smoothstep(0.0, 1.0, dist);
                alpha *= v_life; // Fade based on life
                
                // Add glow effect
                vec3 glowColor = v_color + vec3(0.2);
                fragColor = vec4(glowColor * alpha, alpha * 0.8);
            }
        `;
        
        // Graph shader for convergence visualization
        const graphVertexShader = `#version 300 es
            precision highp float;
            
            layout(location = 0) in vec2 a_position;
            layout(location = 1) in float a_value;
            
            uniform mat4 u_projection;
            uniform mat4 u_view;
            uniform vec2 u_graphBounds; // min, max Y values
            uniform float u_graphWidth;
            uniform float u_time;
            
            out float v_value;
            out float v_distance;
            
            void main() {
                // Map to graph space
                float x = (a_position.x / u_graphWidth - 0.5) * 8.0;
                float y = (a_value - u_graphBounds.x) / (u_graphBounds.y - u_graphBounds.x) * 4.0 - 2.0;
                
                vec3 position = vec3(x, y, 0.0);
                gl_Position = u_projection * u_view * vec4(position, 1.0);
                
                v_value = a_value;
                v_distance = a_position.x / u_graphWidth;
            }
        `;
        
        const graphFragmentShader = `#version 300 es
            precision highp float;
            
            in float v_value;
            in float v_distance;
            
            uniform float u_targetValue; // e
            uniform float u_time;
            
            out vec4 fragColor;
            
            void main() {
                // Color based on distance from e
                float error = abs(v_value - u_targetValue);
                vec3 color;
                
                if (error < 0.01) {
                    // Very close to e - golden
                    color = vec3(1.0, 0.8, 0.2);
                } else if (error < 0.1) {
                    // Close - green
                    color = vec3(0.2, 0.9, 0.4);
                } else {
                    // Far - blue to red gradient
                    float t = clamp(error * 2.0, 0.0, 1.0);
                    color = mix(vec3(0.2, 0.5, 0.9), vec3(0.9, 0.3, 0.2), t);
                }
                
                // Pulse effect for recent points
                float pulse = sin(u_time * 3.0 - v_distance * 10.0) * 0.2 + 0.8;
                color *= pulse;
                
                fragColor = vec4(color, 1.0);
            }
        `;
        
        this.renderer.createProgram('emergence_particles', { 
            vertex: particleVertexShader, 
            fragment: particleFragmentShader 
        });
        
        this.renderer.createProgram('emergence_graph', { 
            vertex: graphVertexShader, 
            fragment: graphFragmentShader 
        });
    }
    
    private createGeometry(): void {
        const gl = this.renderer.getContext();
        
        // Particle quad
        const particleVertices = [
            -0.5, -0.5,   0.5, -0.5,   0.5, 0.5,   -0.5, 0.5
        ];
        const particleIndices = [0, 1, 2, 0, 2, 3];
        
        // Create particle VAO
        this.particleVAO = this.renderer.createVertexArray('emergenceParticleVAO');
        gl.bindVertexArray(this.particleVAO);
        
        // Particle vertices
        const particleVertexBuffer = this.renderer.createBuffer('emergenceParticleVertices');
        gl.bindBuffer(gl.ARRAY_BUFFER, particleVertexBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(particleVertices), gl.STATIC_DRAW);
        gl.vertexAttribPointer(0, 2, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(0);
        
        // Instance buffer for particles
        const particleInstanceBuffer = this.renderer.createBuffer('emergenceParticleInstances');
        gl.bindBuffer(gl.ARRAY_BUFFER, particleInstanceBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, this.maxParticles * 13 * 4, gl.DYNAMIC_DRAW);
        
        // Setup instance attributes
        const stride = 13 * 4;
        gl.vertexAttribPointer(1, 3, gl.FLOAT, false, stride, 0);      // position
        gl.vertexAttribDivisor(1, 1);
        gl.enableVertexAttribArray(1);
        
        gl.vertexAttribPointer(2, 3, gl.FLOAT, false, stride, 3 * 4);  // velocity
        gl.vertexAttribDivisor(2, 1);
        gl.enableVertexAttribArray(2);
        
        gl.vertexAttribPointer(3, 1, gl.FLOAT, false, stride, 6 * 4);  // life
        gl.vertexAttribDivisor(3, 1);
        gl.enableVertexAttribArray(3);
        
        gl.vertexAttribPointer(4, 3, gl.FLOAT, false, stride, 7 * 4);  // color
        gl.vertexAttribDivisor(4, 1);
        gl.enableVertexAttribArray(4);
        
        gl.vertexAttribPointer(5, 1, gl.FLOAT, false, stride, 10 * 4); // size
        gl.vertexAttribDivisor(5, 1);
        gl.enableVertexAttribArray(5);
        
        // Particle indices
        const particleIndexBuffer = this.renderer.createBuffer('emergenceParticleIndices', gl.ELEMENT_ARRAY_BUFFER);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, particleIndexBuffer);
        gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(particleIndices), gl.STATIC_DRAW);
        
        // Create graph VAO
        this.graphVAO = this.renderer.createVertexArray('emergenceGraphVAO');
        gl.bindVertexArray(this.graphVAO);
        
        // We'll create line strip vertices dynamically
        const graphPositionBuffer = this.renderer.createBuffer('emergenceGraphPositions');
        gl.bindBuffer(gl.ARRAY_BUFFER, graphPositionBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, 1000 * 2 * 4, gl.DYNAMIC_DRAW);
        gl.vertexAttribPointer(0, 2, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(0);
        
        const graphValueBuffer = this.renderer.createBuffer('emergenceGraphValues');
        gl.bindBuffer(gl.ARRAY_BUFFER, graphValueBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, 1000 * 4, gl.DYNAMIC_DRAW);
        gl.vertexAttribPointer(1, 1, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(1);
        
        gl.bindVertexArray(null);
    }
    
    private resetSimulation(): void {
        this.trials = 0;
        this.runningAverage = 0;
        this.convergenceHistory = [];
        this.seriesTerms = [];
        this.partialSums = [];
        this.particles = [];
        this.convergenceProgress = 0;
        
        // Initialize series terms
        for (let n = 1; n <= 20; n++) {
            this.seriesTerms.push(1 / this.mathEngine.factorial(n));
        }
        
        // Calculate partial sums
        let sum = 0;
        for (const term of this.seriesTerms) {
            sum += term;
            this.partialSums.push(sum);
        }
    }
    
    private runMonteCarloTrial(): number {
        let sum = 0;
        let count = 0;
        
        while (sum < 1) {
            sum += Math.random();
            count++;
        }
        
        return count;
    }
    
    private spawnParticle(type: 'convergence' | 'series' | 'spiral'): void {
        if (this.particles.length >= this.maxParticles) {
            // Remove oldest particle
            this.particles.shift();
        }
        
        let particle: Particle;
        
        if (type === 'convergence') {
            // Particles that flow from trials to the convergence line
            const angle = Math.random() * Math.PI * 2;
            const radius = 5 + Math.random() * 2;
            
            particle = {
                position: [
                    Math.cos(angle) * radius,
                    Math.sin(angle) * radius,
                    Math.random() * 2 - 1
                ],
                velocity: [
                    -Math.cos(angle) * 0.5,
                    -Math.sin(angle) * 0.5,
                    0
                ],
                life: 1,
                color: [0.3, 0.6, 0.9],
                size: 0.05 + Math.random() * 0.05
            };
        } else if (type === 'series') {
            // Particles representing series terms
            const termIndex = Math.floor(Math.random() * 10);
            const x = -4 + termIndex * 0.8;
            
            particle = {
                position: [x, -3, 0],
                velocity: [0, 0.5, 0],
                life: 1,
                color: [0.9, 0.5, 0.2],
                size: 0.1 * (1 / (termIndex + 1))
            };
        } else {
            // Spiral particles forming the shape of 'e'
            const t = this.spiralPhase + Math.random() * 0.2;
            const r = 1 + t * 0.3;
            
            particle = {
                position: [
                    Math.cos(t * 5) * r,
                    Math.sin(t * 5) * r + t * 0.2 - 2,
                    Math.sin(t * 3) * 0.5
                ],
                velocity: [
                    Math.random() * 0.1 - 0.05,
                    0.1,
                    Math.random() * 0.1 - 0.05
                ],
                life: 1,
                color: [1, 0.8, 0.2],
                size: 0.08
            };
        }
        
        this.particles.push(particle);
    }
    
    update(deltaTime: number): void {
        this.time += deltaTime;
        this.spiralPhase += deltaTime * 0.5;
        
        // Run Monte Carlo trials
        const trialsPerFrame = 5;
        for (let i = 0; i < trialsPerFrame; i++) {
            const hittingTime = this.runMonteCarloTrial();
            this.trials++;
            this.runningAverage = ((this.runningAverage * (this.trials - 1)) + hittingTime) / this.trials;
            
            // Add to history
            this.convergenceHistory.push({
                x: this.trials,
                y: this.runningAverage,
                value: this.runningAverage,
                age: 0
            });
            
            // Limit history size
            if (this.convergenceHistory.length > 500) {
                this.convergenceHistory.shift();
            }
            
            // Spawn convergence particle occasionally
            if (Math.random() < 0.3) {
                this.spawnParticle('convergence');
            }
        }
        
        // Update convergence progress (0 to 1 based on how close we are to e)
        const error = Math.abs(this.runningAverage - Math.E) / Math.E;
        this.convergenceProgress = Math.max(0, 1 - error * 10);
        
        // Spawn series particles
        if (this.time % 0.2 < deltaTime) {
            this.spawnParticle('series');
        }
        
        // Spawn spiral particles continuously
        for (let i = 0; i < 3; i++) {
            this.spawnParticle('spiral');
        }
        
        // Update particles
        for (let i = this.particles.length - 1; i >= 0; i--) {
            const p = this.particles[i];
            
            // Update position
            p.position[0] += p.velocity[0] * deltaTime;
            p.position[1] += p.velocity[1] * deltaTime;
            p.position[2] += p.velocity[2] * deltaTime;
            
            // Update life
            p.life -= deltaTime * 0.5;
            
            // Apply forces based on convergence
            if (this.convergenceProgress > 0.5) {
                // Attract to center as we converge
                const centerForce = 0.5 * this.convergenceProgress;
                p.velocity[0] -= p.position[0] * centerForce * deltaTime;
                p.velocity[1] -= p.position[1] * centerForce * deltaTime;
            }
            
            // Remove dead particles
            if (p.life <= 0) {
                this.particles.splice(i, 1);
            }
        }
        
        // Age convergence history
        for (const point of this.convergenceHistory) {
            point.age += deltaTime;
        }
    }
    
    render(projection: mat4, view: mat4): void {
        const gl = this.renderer.getContext();
        
        // Enable blending for all rendering
        this.renderer.setState({ blending: true, depthTest: true, depthWrite: false });
        
        // Render convergence graph
        if (this.convergenceHistory.length > 1) {
            this.renderGraph(projection, view);
        }
        
        // Render particles
        this.renderParticles(projection, view);
        
        // Restore state
        this.renderer.setState({ blending: false, depthWrite: true });
    }
    
    private renderGraph(projection: mat4, view: mat4): void {
        const gl = this.renderer.getContext();
        
        // Prepare graph data
        const positions: number[] = [];
        const values: number[] = [];
        
        for (let i = 0; i < this.convergenceHistory.length; i++) {
            const point = this.convergenceHistory[i];
            positions.push(i, 0); // x position in graph space
            values.push(point.y);
        }
        
        // Update buffers
        gl.bindBuffer(gl.ARRAY_BUFFER, this.renderer.buffers.get('emergenceGraphPositions') || null);
        gl.bufferSubData(gl.ARRAY_BUFFER, 0, new Float32Array(positions));
        
        gl.bindBuffer(gl.ARRAY_BUFFER, this.renderer.buffers.get('emergenceGraphValues') || null);
        gl.bufferSubData(gl.ARRAY_BUFFER, 0, new Float32Array(values));
        
        // Render
        this.renderer.useProgram('emergence_graph');
        this.renderer.bindVertexArray('emergenceGraphVAO');
        
        // Set uniforms
        this.renderer.setUniform('u_projection', 'mat4', projection);
        this.renderer.setUniform('u_view', 'mat4', view);
        this.renderer.setUniform('u_graphBounds', '2f', [0, 5]); // Y range
        this.renderer.setUniform('u_graphWidth', '1f', this.convergenceHistory.length);
        this.renderer.setUniform('u_targetValue', '1f', Math.E);
        this.renderer.setUniform('u_time', '1f', this.time);
        
        // Draw as line strip
        gl.drawArrays(gl.LINE_STRIP, 0, this.convergenceHistory.length);
        
        // Also draw as points for emphasis
        gl.drawArrays(gl.POINTS, Math.max(0, this.convergenceHistory.length - 20), 
            Math.min(20, this.convergenceHistory.length));
    }
    
    private renderParticles(projection: mat4, view: mat4): void {
        const gl = this.renderer.getContext();
        
        if (this.particles.length === 0) return;
        
        // Prepare instance data
        const instanceData: number[] = [];
        for (const p of this.particles) {
            instanceData.push(
                ...p.position,     // position (vec3)
                ...p.velocity,     // velocity (vec3)
                p.life,           // life (float)
                ...p.color,       // color (vec3)
                p.size,           // size (float)
                0, 0              // padding
            );
        }
        
        // Update instance buffer
        gl.bindBuffer(gl.ARRAY_BUFFER, this.renderer.buffers.get('emergenceParticleInstances') || null);
        gl.bufferSubData(gl.ARRAY_BUFFER, 0, new Float32Array(instanceData));
        
        // Render
        this.renderer.useProgram('emergence_particles');
        this.renderer.bindVertexArray('emergenceParticleVAO');
        
        // Set uniforms
        this.renderer.setUniform('u_projection', 'mat4', projection);
        this.renderer.setUniform('u_view', 'mat4', view);
        this.renderer.setUniform('u_time', '1f', this.time);
        
        // Draw all particles
        gl.drawElementsInstanced(gl.TRIANGLES, 6, gl.UNSIGNED_SHORT, 0, this.particles.length);
    }
    
    setDisplayMode(mode: 'unified' | 'split' | 'focus'): void {
        this.displayMode = mode;
    }
    
    reset(): void {
        this.resetSimulation();
    }
    
    getInfo(): any {
        const error = Math.abs(this.runningAverage - Math.E);
        const errorPercent = (error / Math.E * 100).toFixed(3);
        
        return {
            trials: this.trials,
            runningAverage: this.runningAverage,
            theoreticalValue: Math.E,
            error: error,
            errorPercent: errorPercent,
            convergenceProgress: this.convergenceProgress,
            particleCount: this.particles.length,
            displayMode: this.displayMode
        };
    }
}