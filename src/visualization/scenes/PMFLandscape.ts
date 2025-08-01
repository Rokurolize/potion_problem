/**
 * PMF Landscape Visualization
 * 
 * Visualizes the probability mass function P(τ = n) = (n-1)/n!
 * as a 3D landscape with multiple viewing modes.
 */

import { WebGLRenderer } from '../core/WebGLRenderer';
import { MathEngine } from '../core/MathEngine';
import { mat4, vec3 } from '../math/LinearAlgebra';

interface GridVertex {
    position: vec3;
    normal: vec3;
    texCoord: [number, number];
    value: number;
}

type ViewMode = 'surface' | 'bars' | 'contour' | 'heatmap';

export class PMFLandscape {
    private renderer: WebGLRenderer;
    private mathEngine: MathEngine;
    
    // Grid parameters
    private gridWidth: number = 50;
    private gridDepth: number = 20;
    private maxN: number = 30;
    private vertexCount: number = 0;
    private indexCount: number = 0;
    
    // Rendering resources
    private surfaceVAO: WebGLVertexArrayObject | null = null;
    private barsVAO: WebGLVertexArrayObject | null = null;
    private gridLinesVAO: WebGLVertexArrayObject | null = null;
    
    // View settings
    private viewMode: ViewMode = 'surface';
    private showGrid: boolean = true;
    private showAnnotations: boolean = true;
    private heightScale: number = 10.0;
    
    // Animation
    private time: number = 0;
    private wavePhase: number = 0;
    private pulseAmplitude: number = 0;
    
    // Data
    private pmfValues: number[] = [];
    private cumulativeValues: number[] = [];
    private expectedValuePartial: number[] = [];
    
    constructor(renderer: WebGLRenderer, mathEngine: MathEngine) {
        this.renderer = renderer;
        this.mathEngine = mathEngine;
        this.initialize();
    }
    
    private initialize(): void {
        this.computePMFData();
        this.createShaders();
        this.createGeometry();
    }
    
    private computePMFData(): void {
        this.pmfValues = [];
        this.cumulativeValues = [];
        this.expectedValuePartial = [];
        
        let cumulative = 0;
        let expectedPartial = 0;
        
        for (let n = 0; n <= this.maxN; n++) {
            const pmf = this.mathEngine.pmf(n);
            this.pmfValues.push(pmf);
            
            cumulative += pmf;
            this.cumulativeValues.push(cumulative);
            
            expectedPartial += n * pmf;
            this.expectedValuePartial.push(expectedPartial);
        }
    }
    
    private createShaders(): void {
        // Surface shader
        const surfaceVertexShader = `#version 300 es
            precision highp float;
            
            layout(location = 0) in vec3 a_position;
            layout(location = 1) in vec3 a_normal;
            layout(location = 2) in vec2 a_texCoord;
            layout(location = 3) in float a_value;
            
            uniform mat4 u_projection;
            uniform mat4 u_view;
            uniform mat4 u_model;
            uniform float u_time;
            uniform float u_heightScale;
            uniform float u_wavePhase;
            uniform float u_pulseAmplitude;
            
            out vec3 v_position;
            out vec3 v_normal;
            out vec2 v_texCoord;
            out float v_value;
            out float v_height;
            
            void main() {
                vec3 position = a_position;
                
                // Apply height scaling
                position.y *= u_heightScale;
                
                // Add wave animation
                float wave = sin(position.x * 0.5 + u_wavePhase) * 0.1;
                position.y += wave * u_pulseAmplitude;
                
                // Transform
                vec4 worldPos = u_model * vec4(position, 1.0);
                gl_Position = u_projection * u_view * worldPos;
                
                v_position = worldPos.xyz;
                v_normal = normalize(mat3(u_model) * a_normal);
                v_texCoord = a_texCoord;
                v_value = a_value;
                v_height = position.y;
            }
        `;
        
        const surfaceFragmentShader = `#version 300 es
            precision highp float;
            
            in vec3 v_position;
            in vec3 v_normal;
            in vec2 v_texCoord;
            in float v_value;
            in float v_height;
            
            uniform vec3 u_lightDirection;
            uniform vec3 u_viewPosition;
            uniform float u_time;
            uniform int u_viewMode;
            
            out vec4 fragColor;
            
            vec3 valueToColor(float t) {
                // Beautiful gradient from deep blue to bright orange
                vec3 color1 = vec3(0.1, 0.2, 0.8);
                vec3 color2 = vec3(0.2, 0.8, 0.9);
                vec3 color3 = vec3(0.9, 0.6, 0.2);
                vec3 color4 = vec3(1.0, 0.3, 0.1);
                
                if (t < 0.33) {
                    return mix(color1, color2, t * 3.0);
                } else if (t < 0.67) {
                    return mix(color2, color3, (t - 0.33) * 3.0);
                } else {
                    return mix(color3, color4, (t - 0.67) * 3.0);
                }
            }
            
            void main() {
                vec3 normal = normalize(v_normal);
                vec3 viewDir = normalize(u_viewPosition - v_position);
                
                // Lighting
                float NdotL = max(dot(normal, u_lightDirection), 0.0);
                float NdotV = max(dot(normal, viewDir), 0.0);
                
                // Fresnel rim lighting
                float fresnel = pow(1.0 - NdotV, 2.0);
                
                // Get color based on height
                vec3 baseColor = valueToColor(clamp(v_value * 5.0, 0.0, 1.0));
                
                // Apply lighting
                vec3 ambient = baseColor * 0.3;
                vec3 diffuse = baseColor * NdotL * 0.7;
                vec3 rim = vec3(0.8, 0.9, 1.0) * fresnel * 0.3;
                
                vec3 finalColor = ambient + diffuse + rim;
                
                // Add grid lines effect
                float gridX = abs(fract(v_texCoord.x * float(50)) - 0.5) * 2.0;
                float gridZ = abs(fract(v_texCoord.y * float(20)) - 0.5) * 2.0;
                float grid = 1.0 - smoothstep(0.95, 1.0, max(gridX, gridZ)) * 0.2;
                
                finalColor *= grid;
                
                fragColor = vec4(finalColor, 0.95);
            }
        `;
        
        // Bar shader
        const barVertexShader = `#version 300 es
            precision highp float;
            
            layout(location = 0) in vec3 a_position;
            layout(location = 1) in vec3 a_normal;
            layout(location = 2) in float a_value;
            layout(location = 3) in vec3 a_instanceOffset;
            layout(location = 4) in float a_instanceHeight;
            
            uniform mat4 u_projection;
            uniform mat4 u_view;
            uniform mat4 u_model;
            uniform float u_time;
            uniform float u_heightScale;
            
            out vec3 v_position;
            out vec3 v_normal;
            out float v_value;
            out float v_height;
            
            void main() {
                vec3 position = a_position;
                
                // Apply instance transform
                position.y *= a_instanceHeight * u_heightScale;
                position += a_instanceOffset;
                
                // Add subtle animation
                position.y += sin(u_time + a_instanceOffset.x) * 0.05 * a_instanceHeight;
                
                vec4 worldPos = u_model * vec4(position, 1.0);
                gl_Position = u_projection * u_view * worldPos;
                
                v_position = worldPos.xyz;
                v_normal = normalize(mat3(u_model) * a_normal);
                v_value = a_instanceHeight;
                v_height = position.y;
            }
        `;
        
        this.renderer.createProgram('pmfSurface', { 
            vertex: surfaceVertexShader, 
            fragment: surfaceFragmentShader 
        });
        
        this.renderer.createProgram('pmfBars', { 
            vertex: barVertexShader, 
            fragment: surfaceFragmentShader 
        });
    }
    
    private createGeometry(): void {
        const gl = this.renderer.getContext();
        
        // Create surface mesh
        this.createSurfaceMesh();
        
        // Create bar geometry
        this.createBarGeometry();
        
        // Create grid lines
        this.createGridLines();
    }
    
    private createSurfaceMesh(): void {
        const gl = this.renderer.getContext();
        
        const vertices: number[] = [];
        const normals: number[] = [];
        const texCoords: number[] = [];
        const values: number[] = [];
        const indices: number[] = [];
        
        // Generate grid vertices
        for (let z = 0; z <= this.gridDepth; z++) {
            for (let x = 0; x <= this.gridWidth; x++) {
                // Map grid coordinates to n values
                const n = Math.floor((x / this.gridWidth) * this.maxN);
                const t = z / this.gridDepth;
                
                // Position
                const posX = (x / this.gridWidth - 0.5) * 10;
                const posZ = (z / this.gridDepth - 0.5) * 4;
                
                // Height based on PMF or cumulative
                let height = 0;
                if (t < 0.33) {
                    // PMF values
                    height = this.pmfValues[n] || 0;
                } else if (t < 0.67) {
                    // Cumulative values (scaled down)
                    height = (this.cumulativeValues[n] || 0) * 0.3;
                } else {
                    // Expected value contribution
                    height = (this.expectedValuePartial[n] || 0) * 0.05;
                }
                
                vertices.push(posX, height, posZ);
                texCoords.push(x / this.gridWidth, z / this.gridDepth);
                values.push(height);
                
                // Calculate normal (will be recalculated after indices)
                normals.push(0, 1, 0);
            }
        }
        
        // Generate indices
        for (let z = 0; z < this.gridDepth; z++) {
            for (let x = 0; x < this.gridWidth; x++) {
                const a = z * (this.gridWidth + 1) + x;
                const b = a + 1;
                const c = a + this.gridWidth + 1;
                const d = c + 1;
                
                indices.push(a, c, b, b, c, d);
            }
        }
        
        // Recalculate normals
        this.calculateNormals(vertices, indices, normals);
        
        // Create VAO
        this.surfaceVAO = this.renderer.createVertexArray('pmfSurfaceVAO');
        gl.bindVertexArray(this.surfaceVAO);
        
        // Position buffer
        const posBuffer = this.renderer.createBuffer('pmfSurfacePositions');
        gl.bindBuffer(gl.ARRAY_BUFFER, posBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
        gl.vertexAttribPointer(0, 3, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(0);
        
        // Normal buffer
        const normalBuffer = this.renderer.createBuffer('pmfSurfaceNormals');
        gl.bindBuffer(gl.ARRAY_BUFFER, normalBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(normals), gl.STATIC_DRAW);
        gl.vertexAttribPointer(1, 3, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(1);
        
        // TexCoord buffer
        const texCoordBuffer = this.renderer.createBuffer('pmfSurfaceTexCoords');
        gl.bindBuffer(gl.ARRAY_BUFFER, texCoordBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(texCoords), gl.STATIC_DRAW);
        gl.vertexAttribPointer(2, 2, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(2);
        
        // Value buffer
        const valueBuffer = this.renderer.createBuffer('pmfSurfaceValues');
        gl.bindBuffer(gl.ARRAY_BUFFER, valueBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(values), gl.STATIC_DRAW);
        gl.vertexAttribPointer(3, 1, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(3);
        
        // Index buffer
        const indexBuffer = this.renderer.createBuffer('pmfSurfaceIndices', gl.ELEMENT_ARRAY_BUFFER);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
        gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(indices), gl.STATIC_DRAW);
        
        this.vertexCount = vertices.length / 3;
        this.indexCount = indices.length;
        
        gl.bindVertexArray(null);
    }
    
    private createBarGeometry(): void {
        const gl = this.renderer.getContext();
        
        // Create a single bar (box) that will be instanced
        const barVertices = [
            // Front
            -0.4, 0, 0.4,   0.4, 0, 0.4,   0.4, 1, 0.4,   -0.4, 1, 0.4,
            // Back
            -0.4, 0, -0.4,  -0.4, 1, -0.4,  0.4, 1, -0.4,  0.4, 0, -0.4,
            // Top
            -0.4, 1, -0.4,  -0.4, 1, 0.4,   0.4, 1, 0.4,   0.4, 1, -0.4,
            // Bottom
            -0.4, 0, -0.4,  0.4, 0, -0.4,   0.4, 0, 0.4,   -0.4, 0, 0.4,
            // Right
            0.4, 0, -0.4,   0.4, 1, -0.4,   0.4, 1, 0.4,   0.4, 0, 0.4,
            // Left
            -0.4, 0, -0.4,  -0.4, 0, 0.4,   -0.4, 1, 0.4,   -0.4, 1, -0.4
        ];
        
        const barNormals = [
            // Front
            0, 0, 1,  0, 0, 1,  0, 0, 1,  0, 0, 1,
            // Back
            0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1,
            // Top
            0, 1, 0,  0, 1, 0,  0, 1, 0,  0, 1, 0,
            // Bottom
            0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0,
            // Right
            1, 0, 0,  1, 0, 0,  1, 0, 0,  1, 0, 0,
            // Left
            -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0
        ];
        
        const barIndices = [
            0, 1, 2,   0, 2, 3,    // Front
            4, 5, 6,   4, 6, 7,    // Back
            8, 9, 10,  8, 10, 11,  // Top
            12, 13, 14, 12, 14, 15, // Bottom
            16, 17, 18, 16, 18, 19, // Right
            20, 21, 22, 20, 22, 23  // Left
        ];
        
        // Create instance data
        const instanceOffsets: number[] = [];
        const instanceHeights: number[] = [];
        
        for (let n = 2; n <= this.maxN; n++) {
            const x = ((n / this.maxN) - 0.5) * 10;
            const height = this.pmfValues[n] || 0;
            
            instanceOffsets.push(x, 0, 0);
            instanceHeights.push(height);
        }
        
        // Create VAO
        this.barsVAO = this.renderer.createVertexArray('pmfBarsVAO');
        gl.bindVertexArray(this.barsVAO);
        
        // Bar vertices
        const barVertexBuffer = this.renderer.createBuffer('pmfBarVertices');
        gl.bindBuffer(gl.ARRAY_BUFFER, barVertexBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(barVertices), gl.STATIC_DRAW);
        gl.vertexAttribPointer(0, 3, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(0);
        
        // Bar normals
        const barNormalBuffer = this.renderer.createBuffer('pmfBarNormals');
        gl.bindBuffer(gl.ARRAY_BUFFER, barNormalBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(barNormals), gl.STATIC_DRAW);
        gl.vertexAttribPointer(1, 3, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(1);
        
        // Instance offsets
        const offsetBuffer = this.renderer.createBuffer('pmfBarOffsets');
        gl.bindBuffer(gl.ARRAY_BUFFER, offsetBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(instanceOffsets), gl.STATIC_DRAW);
        gl.vertexAttribPointer(3, 3, gl.FLOAT, false, 0, 0);
        gl.vertexAttribDivisor(3, 1);
        gl.enableVertexAttribArray(3);
        
        // Instance heights
        const heightBuffer = this.renderer.createBuffer('pmfBarHeights');
        gl.bindBuffer(gl.ARRAY_BUFFER, heightBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(instanceHeights), gl.STATIC_DRAW);
        gl.vertexAttribPointer(4, 1, gl.FLOAT, false, 0, 0);
        gl.vertexAttribDivisor(4, 1);
        gl.enableVertexAttribArray(4);
        
        // Index buffer
        const barIndexBuffer = this.renderer.createBuffer('pmfBarIndices', gl.ELEMENT_ARRAY_BUFFER);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, barIndexBuffer);
        gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(barIndices), gl.STATIC_DRAW);
        
        gl.bindVertexArray(null);
    }
    
    private createGridLines(): void {
        // TODO: Implement grid lines for visual reference
    }
    
    private calculateNormals(vertices: number[], indices: number[], normals: number[]): void {
        // Reset normals
        for (let i = 0; i < normals.length; i++) {
            normals[i] = 0;
        }
        
        // Calculate face normals and accumulate
        for (let i = 0; i < indices.length; i += 3) {
            const i1 = indices[i] * 3;
            const i2 = indices[i + 1] * 3;
            const i3 = indices[i + 2] * 3;
            
            // Get vertices
            const v1: vec3 = [vertices[i1], vertices[i1 + 1], vertices[i1 + 2]];
            const v2: vec3 = [vertices[i2], vertices[i2 + 1], vertices[i2 + 2]];
            const v3: vec3 = [vertices[i3], vertices[i3 + 1], vertices[i3 + 2]];
            
            // Calculate face normal
            const edge1: vec3 = [v2[0] - v1[0], v2[1] - v1[1], v2[2] - v1[2]];
            const edge2: vec3 = [v3[0] - v1[0], v3[1] - v1[1], v3[2] - v1[2]];
            
            const faceNormal: vec3 = [
                edge1[1] * edge2[2] - edge1[2] * edge2[1],
                edge1[2] * edge2[0] - edge1[0] * edge2[2],
                edge1[0] * edge2[1] - edge1[1] * edge2[0]
            ];
            
            // Add to vertex normals
            normals[i1] += faceNormal[0];
            normals[i1 + 1] += faceNormal[1];
            normals[i1 + 2] += faceNormal[2];
            
            normals[i2] += faceNormal[0];
            normals[i2 + 1] += faceNormal[1];
            normals[i2 + 2] += faceNormal[2];
            
            normals[i3] += faceNormal[0];
            normals[i3 + 1] += faceNormal[1];
            normals[i3 + 2] += faceNormal[2];
        }
        
        // Normalize
        for (let i = 0; i < normals.length; i += 3) {
            const len = Math.sqrt(normals[i] * normals[i] + normals[i + 1] * normals[i + 1] + normals[i + 2] * normals[i + 2]);
            if (len > 0) {
                normals[i] /= len;
                normals[i + 1] /= len;
                normals[i + 2] /= len;
            }
        }
    }
    
    update(deltaTime: number): void {
        this.time += deltaTime;
        
        // Animate wave phase
        this.wavePhase += deltaTime * 2;
        
        // Pulse amplitude for emphasis
        this.pulseAmplitude = Math.sin(this.time * 0.5) * 0.5 + 0.5;
    }
    
    render(projection: mat4, view: mat4): void {
        const gl = this.renderer.getContext();
        
        // Model matrix
        const model = mat4.create();
        mat4.rotateY(model, model, this.time * 0.1);
        
        if (this.viewMode === 'surface' || this.viewMode === 'heatmap') {
            this.renderer.useProgram('pmfSurface');
            this.renderer.bindVertexArray('pmfSurfaceVAO');
            
            // Set uniforms
            this.renderer.setUniform('u_projection', 'mat4', projection);
            this.renderer.setUniform('u_view', 'mat4', view);
            this.renderer.setUniform('u_model', 'mat4', model);
            this.renderer.setUniform('u_time', '1f', this.time);
            this.renderer.setUniform('u_heightScale', '1f', this.heightScale);
            this.renderer.setUniform('u_wavePhase', '1f', this.wavePhase);
            this.renderer.setUniform('u_pulseAmplitude', '1f', this.pulseAmplitude);
            this.renderer.setUniform('u_lightDirection', '3f', [0.5, 0.7, 0.3]);
            this.renderer.setUniform('u_viewPosition', '3f', [0, 5, 10]);
            this.renderer.setUniform('u_viewMode', '1i', this.viewMode === 'surface' ? 0 : 3);
            
            // Enable transparency and depth
            this.renderer.setState({ blending: true, depthTest: true, depthWrite: true });
            
            // Draw surface
            gl.drawElements(gl.TRIANGLES, this.indexCount, gl.UNSIGNED_SHORT, 0);
            
        } else if (this.viewMode === 'bars') {
            this.renderer.useProgram('pmfBars');
            this.renderer.bindVertexArray('pmfBarsVAO');
            
            // Set uniforms
            this.renderer.setUniform('u_projection', 'mat4', projection);
            this.renderer.setUniform('u_view', 'mat4', view);
            this.renderer.setUniform('u_model', 'mat4', model);
            this.renderer.setUniform('u_time', '1f', this.time);
            this.renderer.setUniform('u_heightScale', '1f', this.heightScale);
            this.renderer.setUniform('u_lightDirection', '3f', [0.5, 0.7, 0.3]);
            this.renderer.setUniform('u_viewPosition', '3f', [0, 5, 10]);
            
            // Draw bars
            gl.drawElementsInstanced(gl.TRIANGLES, 36, gl.UNSIGNED_SHORT, 0, this.maxN - 1);
        }
        
        // Restore state
        this.renderer.setState({ blending: false });
    }
    
    setViewMode(mode: ViewMode): void {
        this.viewMode = mode;
    }
    
    setHeightScale(scale: number): void {
        this.heightScale = Math.max(1, Math.min(20, scale));
    }
    
    getInfo(): any {
        const maxPMF = Math.max(...this.pmfValues);
        const maxIndex = this.pmfValues.indexOf(maxPMF);
        
        return {
            viewMode: this.viewMode,
            maxProbability: maxPMF,
            modeValue: maxIndex,
            expectedValue: Math.E,
            heightScale: this.heightScale
        };
    }
}