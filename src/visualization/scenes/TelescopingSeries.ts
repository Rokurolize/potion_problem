/**
 * Telescoping Series Animation
 * 
 * Visualizes the telescoping series transformation that proves E[τ] = e
 * Shows how ∑_{n=1}^∞ n·P(τ = n) = ∑_{n=1}^∞ 1/n! = e
 */

import { WebGLRenderer } from '../core/WebGLRenderer';
import { MathEngine } from '../core/MathEngine';
import { mat4, vec3 } from '../math/LinearAlgebra';

interface Term {
    index: number;
    value: number;
    position: vec3;
    targetPosition: vec3;
    scale: number;
    opacity: number;
    color: vec3;
    state: 'entering' | 'active' | 'telescoping' | 'summing';
}

interface SeriesStep {
    description: string;
    formula: string;
    terms: Term[];
    partialSum: number;
}

export class TelescopingSeries {
    private renderer: WebGLRenderer;
    private mathEngine: MathEngine;
    
    // Animation state
    private currentStep: number = 0;
    private steps: SeriesStep[] = [];
    private animationPhase: number = 0;
    private time: number = 0;
    private paused: boolean = false;
    private autoAdvance: boolean = true;
    
    // Visualization parameters
    private maxTerms: number = 15;
    private termSpacing: number = 0.8;
    private rowHeight: number = 2.0;
    
    // Rendering resources
    private termVAO: WebGLVertexArrayObject | null = null;
    private textRenderer: WebGLTexture | null = null;
    
    constructor(renderer: WebGLRenderer, mathEngine: MathEngine) {
        this.renderer = renderer;
        this.mathEngine = mathEngine;
        this.initialize();
    }
    
    private initialize(): void {
        this.createShaders();
        this.createGeometry();
        this.setupSteps();
    }
    
    private createShaders(): void {
        const vertexShader = `#version 300 es
            precision highp float;
            
            layout(location = 0) in vec3 a_position;
            layout(location = 1) in vec2 a_texCoord;
            
            // Per-instance attributes
            layout(location = 2) in vec3 a_instancePosition;
            layout(location = 3) in float a_instanceScale;
            layout(location = 4) in vec3 a_instanceColor;
            layout(location = 5) in float a_instanceOpacity;
            
            uniform mat4 u_projection;
            uniform mat4 u_view;
            uniform float u_time;
            
            out vec2 v_texCoord;
            out vec3 v_color;
            out float v_opacity;
            out vec3 v_worldPos;
            
            void main() {
                vec3 position = a_position * a_instanceScale + a_instancePosition;
                
                // Add floating animation
                position.y += sin(u_time * 2.0 + float(gl_InstanceID) * 0.5) * 0.05;
                
                vec4 worldPos = vec4(position, 1.0);
                gl_Position = u_projection * u_view * worldPos;
                
                v_texCoord = a_texCoord;
                v_color = a_instanceColor;
                v_opacity = a_instanceOpacity;
                v_worldPos = position;
            }
        `;
        
        const fragmentShader = `#version 300 es
            precision highp float;
            
            in vec2 v_texCoord;
            in vec3 v_color;
            in float v_opacity;
            in vec3 v_worldPos;
            
            uniform float u_time;
            uniform sampler2D u_texture;
            uniform int u_textureMode;
            
            out vec4 fragColor;
            
            void main() {
                // Create card-like appearance
                float border = 0.02;
                float edge = smoothstep(0.0, border, v_texCoord.x) * 
                            smoothstep(1.0, 1.0 - border, v_texCoord.x) *
                            smoothstep(0.0, border, v_texCoord.y) * 
                            smoothstep(1.0, 1.0 - border, v_texCoord.y);
                
                // Background gradient
                vec3 bgColor = mix(v_color * 0.8, v_color, v_texCoord.y);
                
                // Add subtle glow
                float glow = sin(u_time * 3.0 + v_worldPos.x * 2.0) * 0.1 + 0.9;
                bgColor *= glow;
                
                // If we have text texture, blend it
                vec4 finalColor = vec4(bgColor, edge * v_opacity);
                
                if (u_textureMode == 1) {
                    vec4 textColor = texture(u_texture, v_texCoord);
                    finalColor = mix(finalColor, textColor, textColor.a);
                }
                
                fragColor = finalColor;
            }
        `;
        
        this.renderer.createProgram('telescoping', { vertex: vertexShader, fragment: fragmentShader });
    }
    
    private createGeometry(): void {
        const gl = this.renderer.getContext();
        
        // Create a simple quad for each term
        const vertices = [
            -0.5, -0.3, 0,   0.5, -0.3, 0,   0.5, 0.3, 0,   -0.5, 0.3, 0
        ];
        
        const texCoords = [
            0, 1,   1, 1,   1, 0,   0, 0
        ];
        
        const indices = [0, 1, 2, 0, 2, 3];
        
        // Create VAO
        this.termVAO = this.renderer.createVertexArray('telescopingVAO');
        gl.bindVertexArray(this.termVAO);
        
        // Vertex positions
        const vertexBuffer = this.renderer.createBuffer('telescopingVertices');
        gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
        gl.vertexAttribPointer(0, 3, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(0);
        
        // Texture coordinates
        const texCoordBuffer = this.renderer.createBuffer('telescopingTexCoords');
        gl.bindBuffer(gl.ARRAY_BUFFER, texCoordBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(texCoords), gl.STATIC_DRAW);
        gl.vertexAttribPointer(1, 2, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(1);
        
        // Instance buffer (we'll update this dynamically)
        const instanceBuffer = this.renderer.createBuffer('telescopingInstances');
        gl.bindBuffer(gl.ARRAY_BUFFER, instanceBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, this.maxTerms * 8 * 4, gl.DYNAMIC_DRAW);
        
        // Instance attributes
        // Position (vec3)
        gl.vertexAttribPointer(2, 3, gl.FLOAT, false, 8 * 4, 0);
        gl.vertexAttribDivisor(2, 1);
        gl.enableVertexAttribArray(2);
        
        // Scale (float)
        gl.vertexAttribPointer(3, 1, gl.FLOAT, false, 8 * 4, 3 * 4);
        gl.vertexAttribDivisor(3, 1);
        gl.enableVertexAttribArray(3);
        
        // Color (vec3)
        gl.vertexAttribPointer(4, 3, gl.FLOAT, false, 8 * 4, 4 * 4);
        gl.vertexAttribDivisor(4, 1);
        gl.enableVertexAttribArray(4);
        
        // Opacity (float)
        gl.vertexAttribPointer(5, 1, gl.FLOAT, false, 8 * 4, 7 * 4);
        gl.vertexAttribDivisor(5, 1);
        gl.enableVertexAttribArray(5);
        
        // Index buffer
        const indexBuffer = this.renderer.createBuffer('telescopingIndices', gl.ELEMENT_ARRAY_BUFFER);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
        gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(indices), gl.STATIC_DRAW);
        
        gl.bindVertexArray(null);
    }
    
    private setupSteps(): void {
        this.steps = [];
        
        // Step 1: Original series
        const step1Terms: Term[] = [];
        for (let n = 1; n <= this.maxTerms; n++) {
            const pmf = this.mathEngine.pmf(n);
            step1Terms.push({
                index: n,
                value: n * pmf,
                position: [(n - 1) * this.termSpacing - 5, 0, 0],
                targetPosition: [(n - 1) * this.termSpacing - 5, 0, 0],
                scale: 1,
                opacity: 1,
                color: [0.3, 0.5, 0.9],
                state: 'active'
            });
        }
        
        this.steps.push({
            description: "Original Expected Value Series",
            formula: "E[τ] = Σ n·P(τ = n) = Σ n·(n-1)/n!",
            terms: step1Terms,
            partialSum: this.calculatePartialSum(step1Terms)
        });
        
        // Step 2: Expand the formula
        const step2Terms: Term[] = [];
        for (let n = 1; n <= this.maxTerms; n++) {
            // Split into two parts: n²/n! - n/n!
            const term1: Term = {
                index: n,
                value: n * n / this.mathEngine.factorial(n),
                position: [(n - 1) * this.termSpacing * 2 - 5, this.rowHeight, 0],
                targetPosition: [(n - 1) * this.termSpacing * 2 - 5, this.rowHeight, 0],
                scale: 0.8,
                opacity: 1,
                color: [0.9, 0.4, 0.3],
                state: 'active'
            };
            
            const term2: Term = {
                index: n,
                value: -n / this.mathEngine.factorial(n),
                position: [(n - 1) * this.termSpacing * 2 - 5 + this.termSpacing, this.rowHeight, 0],
                targetPosition: [(n - 1) * this.termSpacing * 2 - 5 + this.termSpacing, this.rowHeight, 0],
                scale: 0.8,
                opacity: 1,
                color: [0.3, 0.7, 0.4],
                state: 'active'
            };
            
            step2Terms.push(term1, term2);
        }
        
        this.steps.push({
            description: "Expand n·(n-1)/n!",
            formula: "= Σ (n²/n! - n/n!)",
            terms: step2Terms,
            partialSum: this.calculatePartialSum(step2Terms)
        });
        
        // Step 3: Simplify
        const step3Terms: Term[] = [];
        for (let n = 1; n <= this.maxTerms; n++) {
            // 1/(n-2)! - 1/(n-1)!
            if (n >= 2) {
                const term1: Term = {
                    index: n,
                    value: 1 / this.mathEngine.factorial(n - 2),
                    position: [(n - 2) * this.termSpacing * 2 - 5, -this.rowHeight, 0],
                    targetPosition: [(n - 2) * this.termSpacing * 2 - 5, -this.rowHeight, 0],
                    scale: 0.9,
                    opacity: 1,
                    color: [0.8, 0.6, 0.2],
                    state: 'active'
                };
                step3Terms.push(term1);
            }
            
            if (n >= 1) {
                const term2: Term = {
                    index: n,
                    value: -1 / this.mathEngine.factorial(n - 1),
                    position: [(n - 1) * this.termSpacing * 2 - 5 + this.termSpacing, -this.rowHeight, 0],
                    targetPosition: [(n - 1) * this.termSpacing * 2 - 5 + this.termSpacing, -this.rowHeight, 0],
                    scale: 0.9,
                    opacity: 1,
                    color: [0.4, 0.6, 0.8],
                    state: 'active'
                };
                step3Terms.push(term2);
            }
        }
        
        this.steps.push({
            description: "Factor and simplify",
            formula: "= Σ (1/(n-2)! - 1/(n-1)!)",
            terms: step3Terms,
            partialSum: this.calculatePartialSum(step3Terms)
        });
        
        // Step 4: Telescoping
        const step4Terms: Term[] = [];
        // Most terms cancel, leaving only first few
        step4Terms.push({
            index: 0,
            value: 1,
            position: [0, 0, 0],
            targetPosition: [0, 0, 0],
            scale: 1.2,
            opacity: 1,
            color: [0.9, 0.7, 0.2],
            state: 'summing'
        });
        
        step4Terms.push({
            index: 1,
            value: 1,
            position: [2, 0, 0],
            targetPosition: [2, 0, 0],
            scale: 1.2,
            opacity: 1,
            color: [0.9, 0.7, 0.2],
            state: 'summing'
        });
        
        // Show some cancelling terms fading
        for (let i = 2; i < 8; i++) {
            step4Terms.push({
                index: i,
                value: 0,
                position: [i * this.termSpacing - 5, -this.rowHeight * 2, 0],
                targetPosition: [i * this.termSpacing - 5, -this.rowHeight * 3, 0],
                scale: 0.6,
                opacity: 0.3,
                color: [0.5, 0.5, 0.5],
                state: 'telescoping'
            });
        }
        
        this.steps.push({
            description: "Telescoping cancellation",
            formula: "Most terms cancel, leaving 1 + 1 + remaining tail",
            terms: step4Terms,
            partialSum: 2 + 0.718281828  // Approximate tail
        });
        
        // Step 5: Final result
        const step5Terms: Term[] = [{
            index: 0,
            value: Math.E,
            position: [0, 0, 0],
            targetPosition: [0, 0, 0],
            scale: 2,
            opacity: 1,
            color: [1, 0.8, 0.2],
            state: 'summing'
        }];
        
        this.steps.push({
            description: "The series converges to e",
            formula: "E[τ] = e ≈ 2.718281828...",
            terms: step5Terms,
            partialSum: Math.E
        });
    }
    
    private calculatePartialSum(terms: Term[]): number {
        return terms.reduce((sum, term) => sum + term.value, 0);
    }
    
    update(deltaTime: number): void {
        if (this.paused) return;
        
        this.time += deltaTime;
        this.animationPhase += deltaTime * 0.3;
        
        // Auto-advance through steps
        if (this.autoAdvance && this.animationPhase > 1) {
            this.nextStep();
            this.animationPhase = 0;
        }
        
        // Animate terms
        const currentStepData = this.steps[this.currentStep];
        if (currentStepData) {
            for (const term of currentStepData.terms) {
                // Smooth position interpolation
                const t = Math.min(1, this.animationPhase * 2);
                const easeT = t * t * (3 - 2 * t); // Smooth step
                
                term.position[0] = term.position[0] + (term.targetPosition[0] - term.position[0]) * easeT;
                term.position[1] = term.position[1] + (term.targetPosition[1] - term.position[1]) * easeT;
                
                // Animate opacity based on state
                if (term.state === 'entering') {
                    term.opacity = Math.min(1, term.opacity + deltaTime * 2);
                } else if (term.state === 'telescoping') {
                    term.opacity = Math.max(0, term.opacity - deltaTime);
                }
            }
        }
    }
    
    render(projection: mat4, view: mat4): void {
        const gl = this.renderer.getContext();
        const currentStepData = this.steps[this.currentStep];
        if (!currentStepData || currentStepData.terms.length === 0) return;
        
        // Prepare instance data
        const instanceData: number[] = [];
        for (const term of currentStepData.terms) {
            instanceData.push(
                ...term.position,      // position (vec3)
                term.scale,           // scale (float)
                ...term.color,        // color (vec3)
                term.opacity          // opacity (float)
            );
        }
        
        // Update instance buffer
        gl.bindBuffer(gl.ARRAY_BUFFER, this.renderer.buffers.get('telescopingInstances') || null);
        gl.bufferSubData(gl.ARRAY_BUFFER, 0, new Float32Array(instanceData));
        
        // Set up rendering
        this.renderer.useProgram('telescoping');
        this.renderer.bindVertexArray('telescopingVAO');
        
        // Set uniforms
        this.renderer.setUniform('u_projection', 'mat4', projection);
        this.renderer.setUniform('u_view', 'mat4', view);
        this.renderer.setUniform('u_time', '1f', this.time);
        this.renderer.setUniform('u_textureMode', '1i', 0); // No texture for now
        
        // Enable blending
        this.renderer.setState({ blending: true, depthTest: true, depthWrite: false });
        
        // Draw all terms
        gl.drawElementsInstanced(gl.TRIANGLES, 6, gl.UNSIGNED_SHORT, 0, currentStepData.terms.length);
        
        // Restore state
        this.renderer.setState({ blending: false, depthWrite: true });
    }
    
    nextStep(): void {
        this.currentStep = (this.currentStep + 1) % this.steps.length;
        this.animationPhase = 0;
    }
    
    previousStep(): void {
        this.currentStep = (this.currentStep - 1 + this.steps.length) % this.steps.length;
        this.animationPhase = 0;
    }
    
    setAutoAdvance(auto: boolean): void {
        this.autoAdvance = auto;
    }
    
    setPaused(paused: boolean): void {
        this.paused = paused;
    }
    
    reset(): void {
        this.currentStep = 0;
        this.animationPhase = 0;
        this.paused = false;
    }
    
    getInfo(): any {
        const currentStepData = this.steps[this.currentStep];
        return {
            currentStep: this.currentStep + 1,
            totalSteps: this.steps.length,
            description: currentStepData?.description || '',
            formula: currentStepData?.formula || '',
            partialSum: currentStepData?.partialSum || 0,
            paused: this.paused,
            autoAdvance: this.autoAdvance
        };
    }
}