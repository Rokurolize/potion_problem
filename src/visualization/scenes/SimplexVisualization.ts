/**
 * N-Dimensional Simplex Volume Explorer
 * 
 * This visualization shows how the volume of an n-dimensional simplex
 * equals 1/n!, providing the geometric foundation for P(τ > n) = 1/n!
 */

import { WebGLRenderer } from '../core/WebGLRenderer';
import { MathEngine } from '../core/MathEngine';
import { mat4, vec3 } from '../math/LinearAlgebra';

interface SimplexVertex {
    position: vec3;
    dimension: number;
    barycentricCoord: number;
}

export class SimplexVisualization {
    private renderer: WebGLRenderer;
    private mathEngine: MathEngine;
    private gl: WebGL2RenderingContext;
    
    private dimension: number = 3;
    private animationTime: number = 0;
    private projectionAngle: number = 0;
    
    // Geometry
    private vertices: SimplexVertex[] = [];
    private edges: number[] = [];
    private faces: number[] = [];
    
    // GPU resources
    private vertexVAO: string = 'simplex-vertices';
    private edgeVAO: string = 'simplex-edges';
    private volumeDisplayVAO: string = 'volume-display';
    
    constructor(renderer: WebGLRenderer, mathEngine: MathEngine) {
        this.renderer = renderer;
        this.mathEngine = mathEngine;
        this.gl = renderer.getContext();
        
        this.initShaders();
        this.generateSimplex(this.dimension);
    }
    
    private initShaders(): void {
        // Vertex shader for simplex rendering
        const vertexShader = `#version 300 es
            precision highp float;
            
            in vec3 position;
            in float dimension;
            in float barycentricCoord;
            
            uniform mat4 projection;
            uniform mat4 view;
            uniform mat4 model;
            uniform float time;
            uniform float projectionAngle;
            
            out vec3 vPosition;
            out float vDimension;
            out float vBarycentric;
            out vec3 vWorldPos;
            
            // Stereographic projection from N-D to 3D
            vec3 stereographicProjection(vec3 pos, float dim) {
                if (dim <= 3.0) return pos;
                
                // Project higher dimensions onto a 3-sphere, then to 3D
                float radius = 1.0 / (1.0 + pos.z * 0.1 * (dim - 3.0));
                vec3 projected = pos * radius;
                
                // Add rotation based on dimension
                float angle = projectionAngle + dim * 0.1;
                mat3 rot = mat3(
                    cos(angle), 0.0, sin(angle),
                    0.0, 1.0, 0.0,
                    -sin(angle), 0.0, cos(angle)
                );
                
                return rot * projected;
            }
            
            void main() {
                vec3 projectedPos = stereographicProjection(position, dimension);
                
                // Animate vertices based on dimension
                float pulse = sin(time * 2.0 + dimension * 0.5) * 0.02;
                projectedPos *= 1.0 + pulse;
                
                vec4 worldPos = model * vec4(projectedPos, 1.0);
                vec4 viewPos = view * worldPos;
                gl_Position = projection * viewPos;
                
                vPosition = projectedPos;
                vDimension = dimension;
                vBarycentric = barycentricCoord;
                vWorldPos = worldPos.xyz;
                
                // Point size based on dimension
                gl_PointSize = mix(8.0, 16.0, dimension / 10.0) / (-viewPos.z);
            }
        `;
        
        const fragmentShader = `#version 300 es
            precision highp float;
            
            in vec3 vPosition;
            in float vDimension;
            in float vBarycentric;
            in vec3 vWorldPos;
            
            uniform float time;
            uniform float currentDimension;
            
            out vec4 fragColor;
            
            vec3 dimensionColor(float dim) {
                // Color gradient based on dimension
                vec3 colors[5] = vec3[5](
                    vec3(0.2, 0.6, 1.0),   // 1D - Blue
                    vec3(0.2, 1.0, 0.6),   // 2D - Green
                    vec3(1.0, 0.6, 0.2),   // 3D - Orange
                    vec3(1.0, 0.2, 0.6),   // 4D - Pink
                    vec3(0.6, 0.2, 1.0)    // 5D+ - Purple
                );
                
                int idx = clamp(int(dim) - 1, 0, 4);
                return colors[idx];
            }
            
            void main() {
                // For point rendering
                vec2 coord = gl_PointCoord - vec2(0.5);
                float dist = length(coord);
                if (dist > 0.5) discard;
                
                vec3 color = dimensionColor(vDimension);
                
                // Highlight current dimension
                if (abs(vDimension - currentDimension) < 0.1) {
                    color *= 1.5;
                }
                
                // Add glow effect
                float glow = exp(-dist * 4.0);
                color += glow * 0.3;
                
                // Fade based on barycentric coordinate (interior vs boundary)
                float alpha = mix(0.7, 1.0, vBarycentric);
                
                fragColor = vec4(color, alpha);
            }
        `;
        
        // Edge shader
        const edgeVertexShader = `#version 300 es
            precision highp float;
            
            in vec3 position;
            uniform mat4 projection;
            uniform mat4 view;
            uniform mat4 model;
            
            void main() {
                gl_Position = projection * view * model * vec4(position, 1.0);
            }
        `;
        
        const edgeFragmentShader = `#version 300 es
            precision highp float;
            
            uniform float alpha;
            out vec4 fragColor;
            
            void main() {
                fragColor = vec4(1.0, 1.0, 1.0, alpha * 0.3);
            }
        `;
        
        // Create shader programs
        this.renderer.createProgram('simplex-vertex', {
            vertex: vertexShader,
            fragment: fragmentShader
        });
        
        this.renderer.createProgram('simplex-edge', {
            vertex: edgeVertexShader,
            fragment: edgeFragmentShader
        });
    }
    
    private generateSimplex(n: number): void {
        this.vertices = [];
        this.edges = [];
        this.faces = [];
        
        // Generate vertices of n-simplex
        // Standard simplex vertices in R^n
        const simplexVertices: vec3[] = [];
        
        if (n === 1) {
            // Line segment
            simplexVertices.push([0, 0, 0]);
            simplexVertices.push([1, 0, 0]);
        } else if (n === 2) {
            // Triangle
            simplexVertices.push([0, 0, 0]);
            simplexVertices.push([1, 0, 0]);
            simplexVertices.push([0.5, Math.sqrt(3)/2, 0]);
        } else if (n === 3) {
            // Tetrahedron
            simplexVertices.push([0, 0, 0]);
            simplexVertices.push([1, 0, 0]);
            simplexVertices.push([0.5, Math.sqrt(3)/2, 0]);
            simplexVertices.push([0.5, Math.sqrt(3)/6, Math.sqrt(6)/3]);
        } else {
            // Higher dimensions - project to 3D
            for (let i = 0; i <= n; i++) {
                const angle = (2 * Math.PI * i) / (n + 1);
                const radius = 1;
                simplexVertices.push([
                    radius * Math.cos(angle),
                    radius * Math.sin(angle),
                    (i - n/2) * 0.1
                ]);
            }
        }
        
        // Create vertex data
        for (let i = 0; i < simplexVertices.length; i++) {
            this.vertices.push({
                position: simplexVertices[i],
                dimension: n,
                barycentricCoord: 1.0 / (n + 1)
            });
        }
        
        // Generate edges (complete graph)
        for (let i = 0; i < simplexVertices.length; i++) {
            for (let j = i + 1; j < simplexVertices.length; j++) {
                this.edges.push(i, j);
            }
        }
        
        // Generate faces (for 3D and lower)
        if (n === 3) {
            // Tetrahedron faces
            this.faces.push(0, 1, 2);
            this.faces.push(0, 1, 3);
            this.faces.push(0, 2, 3);
            this.faces.push(1, 2, 3);
        }
        
        this.updateBuffers();
    }
    
    private updateBuffers(): void {
        const gl = this.gl;
        
        // Vertex data
        const positions: number[] = [];
        const dimensions: number[] = [];
        const barycentrics: number[] = [];
        
        this.vertices.forEach(v => {
            positions.push(...v.position);
            dimensions.push(v.dimension);
            barycentrics.push(v.barycentricCoord);
        });
        
        // Create VAO for vertices
        const vao = this.renderer.createVertexArray(this.vertexVAO);
        if (!vao) return;
        
        gl.bindVertexArray(vao);
        
        // Position buffer
        const posBuffer = this.renderer.createBuffer('simplex-positions');
        gl.bindBuffer(gl.ARRAY_BUFFER, posBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(positions), gl.STATIC_DRAW);
        gl.vertexAttribPointer(0, 3, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(0);
        
        // Dimension buffer
        const dimBuffer = this.renderer.createBuffer('simplex-dimensions');
        gl.bindBuffer(gl.ARRAY_BUFFER, dimBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(dimensions), gl.STATIC_DRAW);
        gl.vertexAttribPointer(1, 1, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(1);
        
        // Barycentric buffer
        const baryBuffer = this.renderer.createBuffer('simplex-barycentrics');
        gl.bindBuffer(gl.ARRAY_BUFFER, baryBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(barycentrics), gl.STATIC_DRAW);
        gl.vertexAttribPointer(2, 1, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(2);
        
        // Edge VAO
        const edgeVao = this.renderer.createVertexArray(this.edgeVAO);
        if (!edgeVao) return;
        
        gl.bindVertexArray(edgeVao);
        
        // Edge vertex positions
        const edgePositions: number[] = [];
        this.edges.forEach(idx => {
            edgePositions.push(...this.vertices[idx].position);
        });
        
        const edgePosBuffer = this.renderer.createBuffer('simplex-edge-positions');
        gl.bindBuffer(gl.ARRAY_BUFFER, edgePosBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(edgePositions), gl.STATIC_DRAW);
        gl.vertexAttribPointer(0, 3, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(0);
        
        gl.bindVertexArray(null);
    }
    
    setDimension(n: number): void {
        this.dimension = Math.max(1, Math.min(10, n));
        this.generateSimplex(this.dimension);
    }
    
    update(deltaTime: number): void {
        this.animationTime += deltaTime;
        this.projectionAngle += deltaTime * 0.2;
    }
    
    render(projection: mat4, view: mat4): void {
        const gl = this.gl;
        
        // Model matrix
        const model = mat4.create();
        mat4.rotateY(model, model, this.animationTime * 0.3);
        
        // Render edges
        this.renderer.setState({ blending: true, depthWrite: false });
        this.renderer.useProgram('simplex-edge');
        this.renderer.setUniform('projection', 'mat4', projection);
        this.renderer.setUniform('view', 'mat4', view);
        this.renderer.setUniform('model', 'mat4', model);
        this.renderer.setUniform('alpha', '1f', 0.5);
        
        this.renderer.bindVertexArray(this.edgeVAO);
        gl.drawArrays(gl.LINES, 0, this.edges.length);
        
        // Render vertices
        this.renderer.setState({ blending: true, depthWrite: true });
        this.renderer.useProgram('simplex-vertex');
        this.renderer.setUniform('projection', 'mat4', projection);
        this.renderer.setUniform('view', 'mat4', view);
        this.renderer.setUniform('model', 'mat4', model);
        this.renderer.setUniform('time', '1f', this.animationTime);
        this.renderer.setUniform('projectionAngle', '1f', this.projectionAngle);
        this.renderer.setUniform('currentDimension', '1f', this.dimension);
        
        this.renderer.bindVertexArray(this.vertexVAO);
        gl.drawArrays(gl.POINTS, 0, this.vertices.length);
    }
    
    getInfo(): { dimension: number; volume: number; formula: string } {
        const volume = this.mathEngine.simplexVolume(this.dimension);
        return {
            dimension: this.dimension,
            volume: volume,
            formula: `Vol(Δ_${this.dimension}) = 1/${this.dimension}! = ${volume.toFixed(6)}`
        };
    }
}